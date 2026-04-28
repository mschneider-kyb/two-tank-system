function [dh, y] = nonlinear_model(h, u, p)
%   NONLINEAR_MODEL implements the nonlinear system equation
%   h: state vector [h1; h2]
%   u: input vector [v; d]
%   p: parameters

    % helper constants
    v1 = sqrt(2*p.g*h(1));
    v2 = sqrt(2*p.g*h(2));

    % differential equation
    dh1 = 1/p.A1 * (u(1) - p.a1*p.mu*v1 - u(2));
    dh2 = 1/p.A2 * (p.a1*p.mu*v1 - p.a2*p.mu*v2);

    dh = [dh1; dh2];
    y = h(2);
end

