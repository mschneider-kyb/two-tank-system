function dy = nonlinear_model(y, u, p)
%NONLINEAR_MODEL implements the nonlinear system equation
%   y: state vector [h1; h2]
%   u: input vector [v; d]
%   p: parameters

    v1 = sqrt(2*p.g*y(1));
    v2 = sqrt(2*p.g*y(2));

    dy1 = 1/p.A1 * (u(1) - p.a1*p.mu*v1 - u(2));
    dy2 = 1/p.A2 * (p.a1*p.mu*v1 - p.a2*p.mu*v2);

    dy = [dy1; dy2];
end

