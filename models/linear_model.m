function [dx, y] = linear_model(x, u, d, sys)
%LINEAR_MODEL Summary of this function goes here
%   Detailed explanation goes here

    dx = sys.A * x + sys.B(1,:) * u + sys.B(2,:) * d;
    y = sys.C * x;
end

