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


