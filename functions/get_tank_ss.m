function sys = get_tank_ss(p)
%GET_TANK_SS Summary of this function goes here
%   Detailed explanation goes here

    % helper variables
    a11 = (p.a1*p.mu*p.g) / sqrt(2*p.g*p.h1_bar);
    a22 = (p.a2*p.mu*p.g) / sqrt(2*p.g*p.h2_bar);

    A = [-a11/p.A1 0;
          a11/p.A2 a22/p.A2];
    b1 = [1/p.A1; 0];
    b2 = [-1/p.A1; 0];
    B = [b1 b2];
    C = [0 1];
    D = 0;

    sys = ss(A, B, C, D);
end

