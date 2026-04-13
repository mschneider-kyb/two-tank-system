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
Kp = 0.00067;
Ki = 0.0000045;
K = pid(Kp,Ki);

% Loop shaping is performed on the open-loop transfer function L(s) = K(s) * G_yv(s).
% Since the disturbance 'd' enters the system after the controller K(s), 
% the characteristic equation (1 + L(s) = 0) depends only on the feedback 
% path via the control input 'v'.
L = G*K;
plot_bode(L(1), {0.00001,10}, "Bode Plot of the Open-Loop Tank System", "bode_plot_pi_controller");
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
Kp1 = 6.5; 
Ki1 = 0.01;
K1 = pid(Kp1,Ki1);

Kp2 = 1.0;
Ki2 = 0.08;
K2 = pid(Kp2,Ki2);

% loop shape inner feedback loop
G1 = G_new(1,1);
L_in = G1 * p.v_max * K1;

figure(1);
margin(L_in);
grid on;

% loop shape outer feedback loop
sys_inner_cl = feedback(L_in, 1, -1);
G2 = G_new(2,1) / G_new(1,1); % tf from h1 to h2
G_outer = 1/p.h_max * G2 * sys_inner_cl;
L_out = G_outer * K2;

L_out2 = 1/p.h_max * ((G2*L_in*K2)/(1+L_in));

figure(2);
margin(L_out);
grid on;

% simulate
% out_casc = sim("sim_cascade_model", "StopTime", "1000");
% plot_results(out_casc);