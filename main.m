clc; close all; clear;

addpath("scripts");
init_params;

[~, sys] = linear_model(~, ~, ~, p);

%% Output control using loopshaping

