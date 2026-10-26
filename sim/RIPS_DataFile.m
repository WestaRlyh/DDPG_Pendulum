% Simscape(TM) Multibody(TM) version: 7.7

% This is a model data file derived from a Simscape Multibody Import XML file using the smimport function.
% The data in this file sets the block parameter values in an imported Simscape Multibody model.
% For more information on this file, see the smimport function help page in the Simscape Multibody documentation.
% You can modify numerical values, but avoid any other changes to this file.
% Do not add code to this file. Do not edit the physical units shown in comments.

%%%VariableName:smiData


%============= RigidTransform =============%

%Initialize the RigidTransform structure array by filling in null values.
smiData.RigidTransform(7).translation = [0.0 0.0 0.0];
smiData.RigidTransform(7).angle = 0.0;
smiData.RigidTransform(7).axis = [0.0 0.0 0.0];
smiData.RigidTransform(7).ID = "";

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(1).translation = [0 40.000000000000007 0];  % mm
smiData.RigidTransform(1).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(1).axis = [0.57735026918962584 -0.57735026918962584 0.57735026918962584];
smiData.RigidTransform(1).ID = "B[motor_base-1:-:pendulum-1]";

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(2).translation = [-50.00267945981625 1.3600535891962551 5.3290705182007514e-14];  % mm
smiData.RigidTransform(2).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(2).axis = [0.57735026918962584 -0.57735026918962562 0.57735026918962595];
smiData.RigidTransform(2).ID = "F[motor_base-1:-:pendulum-1]";

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(3).translation = [63.997320540184241 20.360053589196347 0];  % mm
smiData.RigidTransform(3).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(3).axis = [0.57735026918962584 0.57735026918962584 0.57735026918962584];
smiData.RigidTransform(3).ID = "B[pendulum-1:-:ang_sensor-1]";

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(4).translation = [-1.532107773982716e-13 3.2507330161024584e-13 4.9999999999999405];  % mm
smiData.RigidTransform(4).angle = 1.5707963267948966;  % rad
smiData.RigidTransform(4).axis = [3.3364464747030223e-16 -3.1401849173675503e-16 -1];
smiData.RigidTransform(4).ID = "F[pendulum-1:-:ang_sensor-1]";

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(5).translation = [0 0 35.000000000000014];  % mm
smiData.RigidTransform(5).angle = 3.1415926535897931;  % rad
smiData.RigidTransform(5).axis = [1 0 0];
smiData.RigidTransform(5).ID = "B[ang_sensor-1:-:pendulum-2]";

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(6).translation = [-50.002679459816335 -1.6399464108039954 4.8316906031686813e-13];  % mm
smiData.RigidTransform(6).angle = 2.0943951023931957;  % rad
smiData.RigidTransform(6).axis = [-0.57735026918962584 -0.57735026918962562 -0.57735026918962584];
smiData.RigidTransform(6).ID = "F[ang_sensor-1:-:pendulum-2]";

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(7).translation = [-51.207916985327003 -15.985891183242323 192.50000000000026];  % mm
smiData.RigidTransform(7).angle = 1.5707963267949003;  % rad
smiData.RigidTransform(7).axis = [1 0 0];
smiData.RigidTransform(7).ID = "RootGround[motor_base-1]";


%============= Solid =============%
%Center of Mass (CoM) %Moments of Inertia (MoI) %Product of Inertia (PoI)

%Initialize the Solid structure array by filling in null values.
smiData.Solid(3).mass = 0.0;
smiData.Solid(3).CoM = [0.0 0.0 0.0];
smiData.Solid(3).MoI = [0.0 0.0 0.0];
smiData.Solid(3).PoI = [0.0 0.0 0.0];
smiData.Solid(3).color = [0.0 0.0 0.0];
smiData.Solid(3).opacity = 0.0;
smiData.Solid(3).ID = "";

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(1).mass = 3.7526120227450712;  % kg
smiData.Solid(1).CoM = [0 -47.108213662880935 0];  % mm
smiData.Solid(1).MoI = [6932.9167270079761 2191.2192796563636 6932.9167270079761];  % kg*mm^2
smiData.Solid(1).PoI = [0 0 0];  % kg*mm^2
smiData.Solid(1).color = [0.77647058823529413 0.75686274509803919 0.73725490196078436];
smiData.Solid(1).opacity = 1;
smiData.Solid(1).ID = "motor_base*:*默认";

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(2).mass = 0.53469109053609421;  % kg
smiData.Solid(2).CoM = [18.239476051348863 1.9492367640871078 0];  % mm
smiData.Solid(2).MoI = [21.321267624903019 293.39328632713853 284.95721900422217];  % kg*mm^2
smiData.Solid(2).PoI = [0 0 -17.518159383693153];  % kg*mm^2
smiData.Solid(2).color = [0.77647058823529413 0.75686274509803919 0.73725490196078436];
smiData.Solid(2).opacity = 1;
smiData.Solid(2).ID = "pendulum*:*默认";

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(3).mass = 0.05752164761456637;  % kg
smiData.Solid(3).CoM = [0 0 10.738786279683378];  % mm
smiData.Solid(3).MoI = [15.190455175410962 15.190455175410962 17.976283680979122];  % kg*mm^2
smiData.Solid(3).PoI = [0 0 0];  % kg*mm^2
smiData.Solid(3).color = [0.77647058823529413 0.75686274509803919 0.73725490196078436];
smiData.Solid(3).opacity = 1;
smiData.Solid(3).ID = "ang_sensor*:*默认";


%============= Joint =============%
%X Revolute Primitive (Rx) %Y Revolute Primitive (Ry) %Z Revolute Primitive (Rz)
%X Prismatic Primitive (Px) %Y Prismatic Primitive (Py) %Z Prismatic Primitive (Pz) %Spherical Primitive (S)
%Constant Velocity Primitive (CV) %Lead Screw Primitive (LS)
%Position Target (Pos)

%Initialize the RevoluteJoint structure array by filling in null values.
smiData.RevoluteJoint(2).Rz.Pos = 0.0;
smiData.RevoluteJoint(2).ID = "";

smiData.RevoluteJoint(1).Rz.Pos = -47.422010599395762;  % deg
smiData.RevoluteJoint(1).ID = "[motor_base-1:-:pendulum-1]";

smiData.RevoluteJoint(2).Rz.Pos = -173.81926942822889;  % deg
smiData.RevoluteJoint(2).ID = "[ang_sensor-1:-:pendulum-2]";

