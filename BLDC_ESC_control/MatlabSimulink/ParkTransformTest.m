phi = 45;
abPhi = 30;
Iab = [cos(abPhi*pi/180);sin(abPhi*pi/180)];
Idq = [0;0];

%for phi = 0:20:360
    Idq = rotate(phi*pi/180, Iab)
    plot([0 Iab(1)], [0 Iab(2)]);
    hold on;
    plot([0 Idq(1)], [0 Idq(2)]);
    legend('Iab', 'Idq');
%end
hold off;

function newIdq = rotate(phi, Iab)
    newIdq = [cos(phi) sin(phi); -sin(phi) cos(phi)] * Iab;
end