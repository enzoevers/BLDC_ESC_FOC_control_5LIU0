angles = 0:pi/12:2*pi;
waveform_a = 1:length(angles);
waveform_b = 1:length(angles);
waveform_c = 1:length(angles);


for i = 1:length(angles)
    waveform_a(i) = BackEmfGenerator(angles(i), 1, 1);
    waveform_b(i) = BackEmfGenerator(wrapAngle(angles(i)-2*pi/3), 1, 1);
    waveform_c(i) = BackEmfGenerator(mod((angles(i)+2*pi/3), 2*pi), 1, 1);
end

figure(1)
subplot(3, 1, 1)
plot(angles, waveform_a)
subplot(3, 1, 2)
plot(angles, waveform_b)
subplot(3, 1, 3)
plot(angles, waveform_c)

function angle_in_range = wrapAngle(angle)

if angle < 0
    angle_in_range = 2*pi + angle;
else
    angle_in_range = angle;
end

end

function BackEmf = BackEmfGenerator(angle_e_rad, speed_m_rads, Ke)

backEmfWaveform = 0;

% Generate the waveform
if (0 <= angle_e_rad && angle_e_rad < pi/6)
    backEmfWaveform = angle_e_rad * 6/pi;
elseif (pi/6 <= angle_e_rad && angle_e_rad < 5*pi/6)
    backEmfWaveform = 1;
elseif (5*pi/6 <= angle_e_rad && angle_e_rad < 7*pi/6)
    backEmfWaveform = (pi - angle_e_rad) * 6/pi;
elseif (7*pi/6 <= angle_e_rad && angle_e_rad < 11*pi/6)
    backEmfWaveform = -1;
elseif (11*pi/6 <= angle_e_rad && angle_e_rad < 2*pi)
    backEmfWaveform = (angle_e_rad - 2*pi) * 6/pi;
else
    backEmfWaveform = 0;
end
 
% Scale the waveform
BackEmf = backEmfWaveform * speed_m_rads * Ke;
end