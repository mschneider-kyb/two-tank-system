function [dx, y] = nonlinear_model(x, u, p)
%NONLINEAR_MODEL implements the nonlinear system equation
%   x: state vector [h1; h2]
%   u: input vector [v; d]
%   p: parameters

    v1 = sqrt(2*p.g*x(1));
    v2 = sqrt(2*p.g*x(2));

    dx1 = 1/p.A1 * (u(1) - p.a1*p.mu*v1 - u(2));
    dx2 = 1/p.A2 * (p.a1*p.mu*v1 - p.a2*p.mu*v2);

    dx = [dx1; dx2];
    y = x(2);
end

