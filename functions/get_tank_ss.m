function sys = get_tank_ss(p)
%GET_TANK_SS Summary of this function goes here
%   Detailed explanation goes here

    % helper variables
    gamma1 = (p.a1 * p.mu * p.g) / sqrt(2 * p.g * p.h1_bar);
    gamma2 = (p.a2 * p.mu * p.g) / sqrt(2 * p.g * p.h2_bar);

    A = [-gamma1/p.A1,          0;
          gamma1/p.A2, -gamma2/p.A2];
    B = [1/p.A1, -1/p.A1;
         0,       0];
    C = [0 1];
    D = 0;

    sys = ss(A, B, C, D);
end

