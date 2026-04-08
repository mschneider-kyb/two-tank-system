% load parameters

p.g = 9.81; 
p.mu = 0;

% small outflow diameter (cm)
p.Dso_cm = 0.3;
% medium outflow diameter (cm)
p.Dmo_cm = 0.4;
% large outflow diameter (cm)
p.Dlo_cm = 0.5;

% tank diameters
p.Dt1_cm = 6;
p.Dt2_cm = 5;
p.Dt1 = cm2m(p.Dt1_cm);
p.Dt2 = cm2m(p.Dt2_cm);

% outflow diameters
p.Do1 = cm2m(p.Dmo_cm);
p.Do2 = cm2m(p.Dmo_cm);

% areas
p.A1 = dia2area(p.Dt1);
p.A2 = dia2area(p.Dt2);
p.a1 = dia2area(p.Do1);
p.a2 = dia2area(p.Do2);

function m = cm2m(cm)
    m = cm / 100;
end

function area = dia2area(diameter)
    area = pi * diameter^2 / 4;
end