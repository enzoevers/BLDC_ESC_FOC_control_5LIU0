BLDC_FOC_Params;

new_state = [0; 0; 0; 100; 0];
back_emf = [0 0 0];

for i = 1:50000
    [back_emf, new_state] = SystemDynamics(new_state);
    new_state(4)
end

function [back_emf, states_dot] = SystemDynamics(states)

%#codegen
coder.extrinsic('evalin');
Rs = 0;
Rs = evalin('base','Rs');
Ls = 0;
Ls = evalin('base','Ls');
Ke = 0;
Ke = evalin('base','Ke');
Kt = 0;
Kt = evalin('base','Kt');
J = 0;
J = evalin('base','J');
B = 0;
B = evalin('base','B');
P = 0;
P = evalin('base','P');


h = 0.00003;

BackEmfGenerator = @BackEmf_sinusoid;
%BackEmfGenerator = @BackEmf_Trapezoidal;

A = [1-(Rs/Ls)*h 0 0 (-Ke*BackEmfGenerator(states(5))/Ls)*h 0;
    0 1-(Rs/Ls)*h 0 (-Ke*BackEmfGenerator(states(5) - 2*pi/3)/Ls)*h 0;
    0 0 1-(Rs/Ls)*h (-Ke*BackEmfGenerator(states(5) - 4*pi/3)/Ls)*h 0;
    (Kt*BackEmfGenerator(states(5))/J)*h (Kt*BackEmfGenerator(states(5) - 2*pi/3)/J)*h (Kt*BackEmfGenerator(states(5) - 4*pi/3)/J)*h 1-(B/Ls)*h 0;
    0 0 0 P*h 0];

back_emf = [Ke*BackEmfGenerator(states(5)) Ke*BackEmfGenerator(states(5) - 2*pi/3) Ke*BackEmfGenerator(states(5) - 4*pi/3)] * states(4);
states_dot = A*states;

end

function BackEmf = BackEmf_Trapezoidal(angle_e_rad)
    if(angle_e_rad < 0)
        angle_e_rad = 2*pi + angle_e_rad;
    end

    % Generate the waveform
    if (0 <= angle_e_rad && angle_e_rad < pi/6)
        BackEmf = angle_e_rad * 6/pi;
    elseif (pi/6 <= angle_e_rad && angle_e_rad < 5*pi/6)
        BackEmf = 1;
    elseif (5*pi/6 <= angle_e_rad && angle_e_rad < 7*pi/6)
        BackEmf = (pi - angle_e_rad) * 6/pi;
    elseif (7*pi/6 <= angle_e_rad && angle_e_rad < 11*pi/6)
        BackEmf = -1;
    elseif (11*pi/6 <= angle_e_rad && angle_e_rad < 2*pi)
        BackEmf = (angle_e_rad - 2*pi) * 6/pi;
    else
        BackEmf = 0;
    end
end

function BackEmf = BackEmf_sinusoid(angle_e_rad)
    BackEmf = sin(angle_e_rad);
end