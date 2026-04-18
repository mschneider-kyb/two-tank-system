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
Kp = 0.0002;
Ki = 0.000004;
K = pid(Kp,Ki);

% Loop shaping is performed on the open-loop transfer function L(s) = K(s) * G_yv(s).
% Since the disturbance 'd' enters the system after the controller K(s), 
% the characteristic equation (1 + L(s) = 0) depends only on the feedback 
% path via the control input 'v'.
L = G*K;
plot_bode(L(1), {0.00001,10}, "Bode Plot of the Open-Loop Tank System", "bode_plot_pi_controller");
grid on;

% define set point change
t_final = 1000;
t_ref = [0, 10 - p.dt_eps, 10, 300 - p.dt_eps, 300, t_final];
r_ref = [0.20, 0.20, 0.22, 0.22, 0.22, 0.22]; % define height

% disturbance
%p.d = 0;

% simulate
out_pi = sim("sim_pi_model", "StopTime", "1000");
save_plot = true;
plot_results(out_pi, p, save_plot);

%% Cascade control

% edit the linear model since we assume that we can also measure the other
% state
C_new = eye(2);
D_new = zeros(2, size(sys.B, 2));
sys_new = ss(sys.A, sys.B, C_new, D_new);
G_new = tf(sys_new);

% choose controller
Kp1 = 0.011; 
Ki1 = 0.0;
K1 = pid(Kp1,Ki1);

Kp2 = 5.0;
Ki2 = 0.28;
K2 = pid(Kp2,Ki2);

% loop shape inner feedback loop
G1 = G_new(1,1);
L_in = G1 * K1;

figure(1);
margin(L_in);
grid on;

% loop shape outer feedback loop
sys_inner_cl = feedback(L_in, 1, -1);
G2 = G_new(2,1) / G_new(1,1); % tf from h1 to h2
G_outer = G2 * sys_inner_cl;
L_out = G_outer * K2;

figure(2);
margin(L_out);
grid on;

% define set point change
t_final = 1000;
t_ref = [0, 10 - p.dt_eps, 10, 300 - p.dt_eps, 300, t_final];
r_ref = [0.20, 0.20, 0.22, 0.22, 0.22, 0.22]; % define height

% disturbance
%p.d = 0;

% simulate
out_casc = sim("sim_cascade_model", "StopTime", "1000");
save_plot = true;
plot_results(out_casc, p, save_plot);

%% Reference Trajectory Design for Nonlinear Backstepping
% Parameters for the 2nd order reference model (PT2-Filter)
% Transfer Function: G(s) = w0^2 / (s^2 + 2*D*w0*s + w0^2)

h2_start = 20;      % Initial water level [cm]
step_height = 1;    % Desired change in level [cm]
target_level = h2_start + step_height;

% Test scenarios: [omega_0, Damping]
% High omega_0 means faster tracking but requires more pump power.
% Note: We strictly keep D >= 1 for cases 1, 3, and 4 to avoid oscillation.
configs = [
    1.0, 1.0;
    1.0, 0.4;
    2.0, 1.0;  
    0.5, 1.0;
    4.0, 1.0
];

t = 0:0.01:15; 
figure('Color', 'w'); hold on; grid on;

for i = 1:size(configs, 1)
    w0 = configs(i, 1);
    D  = configs(i, 2);
    
    % Transfer Function G(s)
    sys = tf(w0^2, [1, 2*D*w0, w0^2]);
    [y, ~] = step(sys * step_height, t);
    
    % Generate dynamic legend entry: "Test Case X (w=..., D=...)"
    legend_str = sprintf('Test Case %d (omega_0=%.1f, D=%.1f)', i, w0, D);
    
    plot(t, y + h2_start, 'LineWidth', 2, 'DisplayName', legend_str);
end

% Visual cues
yline(target_level, '--k', 'Target', ...
    'LineWidth', 1.5, ...
    'HandleVisibility', 'off', ...
    'LabelHorizontalAlignment', 'left');

title('PT2 Reference Trajectory Generation (r_d)');
xlabel('Time [s]');
ylabel('Water Level h_2 [cm]');
legend('Location', 'southeast', 'Interpreter', 'none'); % 'none' prevents underscore issues
ylim([19.8, 21.5]);

%% Backstepping control

% trajectory generator parameters
omega_0 = 0.33;
D = 1.0;

% controller gains
c_1 = 0.9;
c_2 = 10.0;

% minimum allowed water level
eps = 1e-5;

% define set point change
t_final = 1000;
t_ref = [0, 10 - p.dt_eps, 10, 300 - p.dt_eps, 300, t_final];
r_ref = [0.20, 0.20, 0.22, 0.22, 0.22, 0.22]; % define height

% disturbance
%p.d = 0;

% simulate
out_back = sim("sim_backstepping_model", "StopTime", "1000");
save_plot = false;
plot_results(out_back, p, save_plot);