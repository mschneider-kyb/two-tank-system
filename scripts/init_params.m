% load parameters

g = 9.81; 
mu = 0;

% small outflow diameter (cm)
Dso_cm = 0.3;
% medium outflow diameter (cm)
Dmo_cm = 0.4;
% large outflow diameter (cm)
Dlo_cm = 0.5;

% tank diameters
Dt1_cm = 6;
Dt2_cm = 5;
Dt1 = cm2m(Dt1_cm);
Dt2 = cm2m(Dt2_cm);

% outflow diameters
Do1 = cm2m(Dmo_cm);
Do2 = cm2m(Dmo_cm);

% areas
A1 = dia2area(Dt1);
A2 = dia2area(Dt2);
a1 = dia2area(Do1);
a2 = dia2area(Do2);

function m = cm2m(cm)
    m = cm / 100;
end

function area = dia2area(diameter)
    area = pi * diameter^2 / 4;
end