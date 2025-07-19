a%%

% https://www.maxongroup.nl/medias/sys_master/root/8841185067038/EN-276.pdf
% 12V 339252 EC 14 flat
% https://online.flippingbook.com/view/1042987/46/
% https://online.flippingbook.com/view/1042987/168/

PhaseTerminationIsStar = 1;

% Resistance
TerminalResistance_Ohm = 15.7;
PhaseResistance_Ohm = 0;
if  (PhaseTerminationIsStar)
    PhaseResistance_Ohm = StarToPhase(TerminalResistance_Ohm);
else
    PhaseResistance_Ohm = DeltaToPhase(TerminalResistance_Ohm);
end
Rs = PhaseResistance_Ohm;

% Inductance at 1Kz (https://online.flippingbook.com/view/1042987/168/)
TerminalInductance_H = 0.000428;
PhaseSelfInductance_H = 0;
if  (PhaseTerminationIsStar)
    PhaseSelfInductance_H = StarToPhase(TerminalInductance_H);
else
    PhaseSelfInductance_H = DeltaToPhase(TerminalInductance_H);
end
Ls = PhaseSelfInductance_H;

StatorInductanceFluctuation_H = -0.00002;
StatorMutualInductance_H = 0.00002;
StatorNetInductance_H = PhaseSelfInductance_H - StatorMutualInductance_H;

% Mechanical
RotorInertia_KgM2 = 0.00000011;
J = RotorInertia_KgM2;
RotorDamping_NmRads = 0;
FrictionCoefficient_Nms = 0.000001;
B = FrictionCoefficient_Nms;

% Motor constants
MotorKv = 1890;
MotorKt = 0.00506;
TimeConstant_s = 0.0675; 
AlignmentDuration_s = 3 * TimeConstant_s;

% Back EMF
MaximumRotorInducedBackEmf_V = 1;
RotorSpeedUsedForBackEmfMeasurement_RPM = 1890;
BackEmfConstant_VRpm = 1/MotorKv;
BackEmfConstant_VRads = 1/(MotorKv*(2*pi/60));
Ke = BackEmfConstant_VRads;
Kt = MotorKt;

NominalTorque_Nm = 0.00183;
MotorStatorTeeth = 0;
MotorPolePairs = 4;
P = MotorPolePairs;

%%
% Battery parameters
BatteryVoltage = 12;
BatteryCRating = 70;
BatteryCapacityAh = 1.4;

MotorCount = 1;
MaxCurrentDraw = (BatteryCapacityAh * BatteryCRating)/MotorCount;

%% Control
MotorNomicalElectricalFrequency = MotorPolePairs *(RotorSpeedUsedForBackEmfMeasurement_RPM/60);
Svpwm_freq_hz = 20000; % MotorNomicalElectricalFrequency * 10

%% Model
%Ts = (1/Svpwm_freq_hz)/50;
Ts = 0.0001;

%% Functions

function Y = StarToPhase(TerminalMeasurment)
    Y = (1/2)*TerminalMeasurment;
end

function Y = DeltaToPhase(TerminalMeasurment)
    Y = (3/2)*TerminalMeasurment;
end