% load parameters

p.g = 9.81; 
p.mu = 1;
p.c = p.mu * sqrt(2*p.g);
p.h_max = cm2m(30);

% small outflow diameter (cm)
p.Dso_cm = 0.4;
% medium outflow diameter (cm)
p.Dmo_cm = 0.5;
% large outflow diameter (cm)
p.Dlo_cm = 0.6;

% tank diameters
p.Dt1 = cm2m(5);
p.Dt2 = cm2m(4.5);

% outflow diameters
p.Do1 = cm2m(p.Dmo_cm);
p.Do2 = cm2m(p.Dmo_cm);

% areas
p.A1 = dia2area(p.Dt1);
p.A2 = dia2area(p.Dt2);
p.a1 = dia2area(p.Do1);
p.a2 = dia2area(p.Do2);
p.k_1 = p.a1 / p.A1;
p.k_2 = p.a2 / p.A2;

% stationary states
p.h2_bar = cm2m(20);
p.h1_bar = (p.a2/p.a1)^2 * p.h2_bar; 
p.v_bar = p.a1*p.mu*sqrt(2*p.g*p.h1_bar);
p.v_max = 2*p.v_bar;

% disturbance
p.d = 5e-6;                                     % [d] = m^3/s
p.dt_on = 300;
p.dt_off = 350;

%% helper functions
function m = cm2m(cm)
    m = cm / 100;
end

function area = dia2area(diameter)
    area = pi * diameter^2 / 4;
end