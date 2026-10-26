%%1.创建环境
mdl = "RIPS_model_pil";% rlCartPoleSimscapeModel为你的环境变量名
open_system(mdl)

% 调用Simulink预定义的环境
% env = rlPredefinedEnv("CartPoleSimscapeModel-Continuous")% 动作空间连续，采用DDPG训练（本例）

%% 2.创建环境接口
% 根据之前的模型定义基本的动作值和观测值信息，都是连续值，取值有一定的范围。
actInfo = rlNumericSpec([1,1],...
    "LowerLimit",-10, ...
    "UpperLimit",10); % 动作值，维度为1×1的标量
actInfo.Name = "force";

% 定义观测值的信息
% 观测值，维度为6×1的向量，即6个观测值
% alpha_sin alpha_cos theta_sin theta_cos alpha_deta theta_deta
obsInfo = rlNumericSpec([4,1],... 
    'LowerLimit', [-12.56 -3.14 -inf -inf]',...    % 降低速度限制（原来是-100）
    'UpperLimit', [12.56 3.14 inf inf]');           % 降低速度限制（原来是100）
obsInfo.Name = 'observations';
numObservation = obsInfo.Dimension(1);

% 将动作值、观测值这些基本信息、模型、以及模型中对应的强化学习智能体模块的信息，
% 同时传递给rlSimulinkEnv函数，生成一个env变量，
env = rlSimulinkEnv("RIPS_model_pil","RIPS_model_pil/RL Agent",obsInfo,actInfo);


%设置仿真时间 Tf 和智能体的采样时间 Ts
Ts = 0.04;
Tf = 10;
rng(0)%固定随机生成器种子，保证每次运行生成的随机数都一样，方便复现结果。

%% 3. 创建DDPG智能体
% 包括两个路径：状态路径 + 动作路径
% 使用深度学习工具箱提供的函数定义这个网络的各层
%（1）网络定义的第一种方法：使用深度学习工具箱提供的函数
%（2）网络定义的第二种方法：利用Deep Network Designer工具（图形化操作界面）

% 状态路径：对状态输入进行处理
statePath = [
    featureInputLayer(prod(obsInfo.Dimension),Name="NetObsInLayer")% 输入层，接收倒立摆的状态信息
    fullyConnectedLayer(128)    % 第一个"理解"层，就像大脑的第一层处理。增大第一层，看得更全面
    reluLayer                   % 激活函数，让网络能学习非线性关系
    fullyConnectedLayer(200,Name="sPathOut")];  % 最后的"决策"层，准备与动作信息合并，最后层保持精简

% 动作路径：对动作输入进行处理
actionPath = [
    featureInputLayer(prod(actInfo.Dimension),Name="NetActInLayer")   % 输入维度为1（控制力矩）
    % fullyConnectedLayer(64)       % 第一层扩展，增强表达能力
    % reluLayer                     % 添加非线性
    fullyConnectedLayer(200,Name="aPathOut",BiasLearnRateFactor=0)];  % 输出维度与状态路径匹配

% 公共路径：状态路径和动作路径汇总连接在一起
commonPath = [
    additionLayer(2,Name="add")
    reluLayer
    fullyConnectedLayer(1,Name="CriticOutput")];

% 创建层次图变量，将三个网络依次存入层次图变量
criticNetwork = layerGraph(statePath);
criticNetwork = addLayers(criticNetwork,actionPath);
criticNetwork = addLayers(criticNetwork,commonPath);

% 连接网络
criticNetwork = connectLayers(criticNetwork,"sPathOut","add/in1");
criticNetwork = connectLayers(criticNetwork,"aPathOut","add/in2");
criticNetwork = dlnetwork(criticNetwork);

summary(criticNetwork)
% figure
% plot(criticNetwork)

critic = rlQValueFunction(criticNetwork, ...  
    obsInfo,actInfo,...
    ObservationInputNames="NetObsInLayer", ...
    ActionInputNames="NetActInLayer");

% Actor网络结构与状态路径对应
actorNetwork = [
    featureInputLayer(prod(obsInfo.Dimension))
    fullyConnectedLayer(128)    % 对应statePath第一层
    reluLayer
    % fullyConnectedLayer(64)     % 对应statePath第二层
    % reluLayer
    fullyConnectedLayer(200)     % 对应statePath第三层
    reluLayer
    fullyConnectedLayer(prod(actInfo.Dimension))
    tanhLayer
    scalingLayer(Scale=max(actInfo.UpperLimit))];

actorNetwork = dlnetwork(actorNetwork);
summary(actorNetwork)

actor = rlContinuousDeterministicActor(actorNetwork,obsInfo,actInfo);

%% 4.创建DDPG智能体
% 特殊的训练actor和critic% 降低学习率
criticOptions = rlOptimizerOptions(LearnRate=1e-03,GradientThreshold=1);
actorOptions = rlOptimizerOptions(LearnRate=1e-04,GradientThreshold=1);

% 首先通过rlDDPGAgentOptions函数设置智能体选项，如采样时间、经验缓存大小和MiniBatchSize等；
agentOptions = rlDDPGAgentOptions(...
    SampleTime=Ts,...
    ActorOptimizerOptions=actorOptions,...
    CriticOptimizerOptions=criticOptions,...
    ExperienceBufferLength=2e6,...
    MiniBatchSize=256);

% % 设置初始动作值
% agentOptions.InitialActionValue = 0.5;  % 设置一个初始动作值，范围在[-1,1]之间

% 加入噪声随机化调整动作，对动作空间进行探索，不局限于某一个动作，让动作空间的范围尽可能地扩大
agentOptions.NoiseOptions.Variance = 1;        % 初始探索噪声
agentOptions.NoiseOptions.VarianceDecayRate = 5e-5;  % 缓慢衰减

%根据创建的actor网络和critic网络对象，以及智能体选项设置，创建智能体对象。agent即为在simulink模块中的需要索引的agent变量
agent = rlDDPGAgent(actor,critic,agentOptions);
% agent = rlDDPGAgent(obsInfo,actInfo,agentOptions);
%% 训练并验证智能体
%训练分为两个步骤：首先对机器人进行仿真，采集机器人所有的数据，即经验的积累，
% 然后根据积累的经验数据，进行神经网络参数的优化更新（涉及梯度计算，随机梯度下降算法、adams等方法）

% 设置训练参数
maxepisodes = 2000; % 最大仿真次数/训练轮次/训练回合
maxsteps = ceil(Tf/Ts); % 每次仿真最大步数，即每次仿真最多进行1250步（采样1250次）

% train DDPG Agent
trainingOptions = rlTrainingOptions(...
    MaxEpisodes=maxepisodes,...                    % 最大训练回合数
    MaxStepsPerEpisode=maxsteps,...             % 每回合最大步数      
    ScoreAveragingWindowLength=5,...      % 平均奖励计算窗口
    Verbose=true,...
    Plots="training-progress",...
    StopTrainingCriteria="AverageReward",...   % 使用平均奖励作为停止标准
    StopTrainingValue=-150,...              % 平均奖励达到-100时停止
    SaveAgentCriteria="EpisodeReward",...  % 保存条件
    SaveAgentValue=-200);                   % 当单回合损失小于-80时保存


% % 选择一些并行化的方法，利用本地的CPU进行网络的并行训练加速
% agentOptions.SaveExperienceBufferWithAgent = true;
% trainingOptions.UseParallel = false; % 这里使用了GPU所以设置为了false
% trainingOptions.ParallelizationOptions.Mode = "async";
% trainingoptions.Parallelizationoptions.DataTosendFromWorkers = "experience";
% trainingoptions.Parallelizationoptions.StepsUntilDataIsSent = 30;
% trainingoptions.Parallelizationoptions.WorkerRandomSeeds = -1,
doTraining = true;% 选true,false择重新训练智能体还是调用预训练的智能体
%% 

%监督训练过程
%使用 train函数训练智能体。训练过程计算量大，一般需要几个小时才能完成。
% 可以将 doTraining设为 false，直接导入一个预训练好的智能体，也可以将 doTraining设置为true，重新开始训练。
if doTraining    
    % Train the agent.
     % Train the agent.
    % 强化学习工具箱提供的train函数，将接收agent、env和trainingOptions作为输入，
    % 对环境env进行仿真，进行智能体参数的更新。
    % 也可以自定义一个智能体，并自定义一个对应的训练循环，在工具箱中提供了相应的支持
    
    trainingStats = train(agent,env,trainingOptions);
else
    % Load the pretra ined agent for the example.
    load("success1.mat","agent")    
end

%% 7.仿真验证
% 利用强化学习工具箱的函数
simOptions = rlSimulationOptions(MaxSteps=500);%设置仿真的最大步长
experience = sim(env,agent,simOptions);
%bdclose(mdl)

%% 修改奖励函数设计
% 在Simulink模型RIPSv5_changepil中添加奖励计算模块：
% 确保奖励函数能够反映甩杆和稳定平衡的逻辑


