function sys = get_tank_ss(p)
%   GET_TANK_SS Returns the linearized state-space model of the two-tank system
%   Calculates the A, B, C, and D matrices based on the operating point 
%   defined in the parameter structure 'p'.

    % Linearization constants (partial derivatives of the flow equations)
    % These represent the change in outflow velocity relative to the change in level
    gamma1 = (p.a1 * p.mu * p.g) / sqrt(2 * p.g * p.h1_bar);
    gamma2 = (p.a2 * p.mu * p.g) / sqrt(2 * p.g * p.h2_bar);

    % System Matrix A: Describes the internal dynamics/coupling between tanks
    A = [-gamma1/p.A1,          0;
          gamma1/p.A2, -gamma2/p.A2];

    % Input Matrix B: Maps control input (pump) and disturbance to state rates
    % u(1): Pump voltage/flow, u(2): Disturbance flow
    B = [1/p.A1, -1/p.A1;
         0,       0];

    % Output Matrix C: Selects h2 as the measured output
    C = [0 1];

    % Direct Feedthrough Matrix D: No direct path from input to output
    D = 0;

    % Create State-Space object
    sys = ss(A, B, C, D);
    
    % Note: If p.mu is a 'ureal' object, sys will automatically be a USS model.
end

