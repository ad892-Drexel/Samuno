%% Traj_Creator
clear
clc
close all

%% Time Step and Duration for All Trajs
ts=0.001; % This cannot change
dur=10; % Make Sure this value is >= to the actual duration of the simulation

%% Create Caudal Traj
amp_C=-20;
bias_C=0;
phase_C=0;
freq_C=1;

Drivers.Caudal_Driver= createSineWave(amp_C, bias_C, phase_C, freq_C, ts, dur);

%% Create Dorsal Traj
amp_D=-20;
bias_D=0;
phase_D=180;
freq_D=1;

Drivers.Dorsal_Driver= createSineWave(amp_D, bias_D, phase_D, freq_D, ts, dur);

%% Create Anal Traj
amp_A=-20;
bias_A=0;
phase_A=180;
freq_A=1;

Drivers.Anal_Driver= createSineWave(amp_A, bias_A, phase_A, freq_A, ts, dur);

%% Create Ped Traj
amp_P=0;
bias_P=0;
phase_P=45;
freq_P=1;

Drivers.Ped_Driver= createSineWave(amp_P, bias_P, phase_P, freq_P, ts, dur);

%% Create Mid Traj
amp_M=0;
bias_M=0;
phase_M=90;
freq_M=1;

Drivers.Mid_Driver= createSineWave(amp_M, bias_M, phase_M, freq_M, ts, dur);

%% Pectoral Fins
timeArray = 0:ts:dur;
PectL_A_Start = 0;
PectL_B_Start = 0;
PectR_A_Start = 0;
PectR_B_Start = 0;

PectL_A_End   = 0;
PectL_B_End   = 0;
PectR_A_End   = 0;
PectR_B_End   = 0;

Drivers.Pect_LA_Driver=[timeArray' linspace(PectL_A_Start,PectL_A_End,length(timeArray))'];
Drivers.Pect_LB_Driver=[timeArray' linspace(PectL_B_Start,PectL_B_End,length(timeArray))'];

Drivers.Pect_RA_Driver=[timeArray' linspace(PectR_A_Start,PectR_A_End,length(timeArray))'];
Drivers.Pect_RB_Driver=[timeArray' linspace(PectR_B_Start,PectR_B_End,length(timeArray))'];

%%
save('Joint_Drives','Drivers')
