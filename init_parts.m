%% Physical Specs Init file for Samuno Model

%%  Set Simulation Appearance

colors.nose     = [4,90,141]/255;
colors.mid_body = [4,90,141]/255;
colors.peduncle = [4,90,141]/255;

colors.dorsal   = [227,26,28]/255;
colors.anal     = [227,26,28]/255;
colors.caudal   = [227,26,28]/255;
colors.pectL    = [227,26,28]/255;
colors.pectR    = [227,26,28]/255;
%% CoB
offset=-.01;
gravity=9.81;
Flooded_Scale=1;

%% Samuno Nose Specs
Nose.X_Area=0.0208;
Nose.Y_Area=0.0415;
Nose.Z_Area=0.0316;
Nose.Volume=0.0042;
Nose.Added_Water_Mass=998*Nose.Volume*Flooded_Scale;

Nose.X_Cd=0.86;  % 0.35;
%Nose.X_Cd=0.35; 
Nose.Y_Cd=0.59;
Nose.Z_Cd=0.33;

a=0.145;
b=0.09;
c=0.267;
rho=997;
m = (4*pi*rho*a*b*b)/3;
ecc = sqrt(1-((b/a)^2));
alpha0 = ((2*(1-(ecc^2)))/(ecc^3))*((0.5*log((1+ecc)/(1-ecc))-ecc));
beta0 = (1/(ecc^2))-(((1-(ecc^2))/(2*(ecc^3)))*(log((1+ecc)/(1-ecc))));
k1 = (alpha0)/(2-alpha0);
k2 = (beta0)/(2-beta0);
xudot = k1*m;

Nose.X_am=xudot;
Nose.Y_am=pi*997*(b)^2*.267;
Nose.Z_am=pi*997*(a/2)^2*.267;

Nose.CoM=   [0, 0, -0.15];
Nose.Mass=  Nose.Added_Water_Mass;
%Nose.MoI=   moment_of_inertia_calc(CoM,Nose_Components);

Nose.MoI= [0.0244833, 0.0213168, 0.0128617];
Nose.PoI=   [0 0 0];


%% Samuno Middle Body Specs
Mid_Body.X_Area=0.0130;
Mid_Body.Y_Area=0.0131;
Mid_Body.Z_Area=0.00852;
Mid_Body.Volume=0.00111;
Mid_Body.Added_Water_Mass=998*Mid_Body.Volume*Flooded_Scale;

Mid_Body.X_Cd=0;
Mid_Body.Y_Cd=0.67;
Mid_Body.Z_Cd=0.33;

Mid_Body.X_am=0;
Mid_Body.Y_am=pi*997*(0.125/2)^2*.114;
Mid_Body.Z_am=pi*997*(.0875/2)^2*.114;


Mid_Body.Mass=Mid_Body.Added_Water_Mass;
Mid_Body.CoM=[0, 0, -0.31];
Mid_Body.MoI=[0.0027378, 0.00139362, 0.00247784];
Mid_Body.PoI=[-4.55517e-06, -3.13083e-10, -3.30558e-07];


%% Samuno Peduncle Specs
Pedunc.X_Area=0.00234;
Pedunc.Y_Area=0.00829;
Pedunc.Z_Area=0.00451;
Pedunc.Volume=0.000293;
Pedunc.Added_Water_Mass=998*Pedunc.Volume*Flooded_Scale;

Pedunc.X_Cd=0;
Pedunc.Y_Cd=0.79;
Pedunc.Z_Cd=0.40;

Pedunc.X_am=0;
Pedunc.Y_am=pi*997*(.07/2)^2*.121;
Pedunc.Z_am=pi*997*(.056/2)^2*.121;


Pedunc.Mass=Pedunc.Added_Water_Mass;
Pedunc.CoM=[0, 0, -0.43];
Pedunc.MoI=[0.000452531, 0.000369179, 0.000145516];
Pedunc.PoI=[-9.63997e-06, -7.68844e-10, 1.11719e-08];

%% Samuno Pectoral Fins Specs

Pect.X_Area=0.000221;
Pect.Y_Area=0.006134;
Pect.Z_Area=0.000171;

Pect.X_Cd=0.01;
Pect.Y_Cd=1.28;
Pect.Z_Cd=0.01;

Pect.X_am=0;
Pect.Y_am=0.2227;
Pect.Z_am=0;
Pect.Percent_Scale=0.85;

Pect.Mass=0.004;
Pect.CoM=[0, -0.05, 0];
Pect.MoI=[4.41638e-06, 2.21787e-06, 2.20117e-06];
Pect.PoI=[0, 0, 0];

%% Samuno Middle Fins Specs

Mid_Fins.X_Area= 0.00014;
Mid_Fins.Y_Area= 0.00713;
Mid_Fins.Z_Area= 0.000276;

Mid_Fins.X_Cd= .01;
Mid_Fins.Y_Cd= 1.28;
Mid_Fins.Z_Cd= .01;

Mid_Fins.X_am=0;
Mid_Fins.Y_am=0.2395;
Mid_Fins.Z_am=0;

Mid_Fins.Mass=0.004;
Mid_Fins.CoM=[0, 0.0303425, -0.0304674];
Mid_Fins.MoI=[5.58344e-06, 4.17528e-06, 1.41083e-06];
Mid_Fins.PoI=[-4.38311e-07, -8.9726e-25, 6.50186e-25];


%% Samuno Caudal Specs
Caudal.X_Area=0.00044;
Caudal.Y_Area=0.0187;
Caudal.Z_Area=0.000274;

Caudal.Y_L=0.143;

Caudal.X_Cd=.01;
Caudal.Y_Cd=1.28;
Caudal.Z_Cd=.01;

Caudal.X_am=0;
Caudal.Y_am=1.144;
Caudal.Z_am=0;

Caudal.Mass=0.010;
Caudal.CoM=[0, 0, -0.075383];
Caudal.MoI=[3.57907e-05, 1.30903e-05, 2.27071e-05];
Caudal.PoI=[-2.22623e-22, -1.94883e-24, -0];

%% Total Robot Mass

Total_Robot_Mass=Nose.Mass + Mid_Body.Mass + Pedunc.Mass + Caudal.Mass + Mid_Fins.Mass*2 + Pect.Mass*2;

%% GUI Properties

xCOM     = Nose.CoM(3);
zCOM     = Nose.CoM(1);
xCOB     = 0;
zCOB     = 0;
TotalMass= Total_Robot_Mass;
init_vel = 0;

%% Other Things To make the Simulation Work
% Set Noise For Force Production
noise_mean=1;
noise_var=0.001;
noise_sample_time=0.001;

Force_Scale=1;
simulation_ts=0.001;
duration=10;

