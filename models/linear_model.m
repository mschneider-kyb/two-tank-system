function [dx, sys] = linear_model(x, u, d, p)
%LINEAR_MODEL Summary of this function goes here
%   Detailed explanation goes here

    % helper variables
    a11 = (p.a1*p.mu*p.g) / sqrt(2*p.g*h1_bar);
    a22 = (p.a2*p.mu*p.g) / sqrt(2*p.g*h2_bar);

    A = [-a11 0;
          a11 a22];
    b1 = [1; 0];
    b2 = [-1/p.A1; 0];
    B = [b1 b2];
    C = [0 1];
    D = 0;

    dx = A * x + b1 * u + b2 * d;
    y = C * x;

    sys = ss(A, B, C, D);
end

