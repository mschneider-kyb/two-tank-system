clc; close all; clear;

addpath("scripts", "functions", "models");
init_params;

%% Analysis

% get system
sys = get_tank_ss(p);
G = tf(sys);

% check stability
if all(real(eig(sys)) < 0)
    disp("System is stable.");
else
    disp("System is not stable.");
end

bode(G);
grid on;

%% Output control using loopshaping

% get controller
Kp = 0.00015;
Ki = 0.000001;
K = pid(Kp,Ki);

% Loop shaping is performed on the open-loop transfer function L(s) = K(s) * G_yv(s).
% Since the disturbance 'd' enters the system after the controller K(s), 
% the characteristic equation (1 + L(s) = 0) depends only on the feedback 
% path via the control input 'v'.
L = G*K;
margin(L(1),{0.00001,10});
grid on;

% simulate
out_pi = sim("sim_pi_model", "StopTime", "1000");
plot_results(out_pi);

%% Cascade control

% edit the linear model since we assume that we can also measure the other
% state
C_new = eye(2);
D_new = zeros(2, size(sys.B, 2));
sys_new = ss(sys.A, sys.B, C_new, D_new);
G_new = tf(sys_new);

% choose controller
Kp1 = 0.001;
Ki1 = 0.0;
K1 = pid(Kp1,Ki1);

Kp2 = 0.000001;
Ki2 = 0.0;
K2 = pid(Kp2,Ki2);

% loop shape inner feedback loop
L_in = G_new(1,1)*K1;
margin(L_in,{0.00001,10});
grid on;

% loop shape outer feedback loop
L_out = G_new(2,1)*K2;
margin(L_out,{0.00001,10});
grid on;