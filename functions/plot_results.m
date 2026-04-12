function plot_results(out)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    % extract data
    time = out.tout;
    h = out.logsout.get('h').Values.Data;
    h1 = h(:,1);
    h2 = h(:,2);
    v = out.logsout.get('v').Values.Data;
    d = out.logsout.get('d').Values.Data;
    
    % create plot
    figure('Color', 'w');

    % left axis
    yyaxis left
    plot(time, h1, '--', 'LineWidth', 1.5, 'DisplayName', 'Tank 1');
    hold on;
    plot(time, h2, '-', 'LineWidth', 1.5, 'DisplayName', 'Tank 2');
    ylabel('Fill Level [m]');
    ylim([0.19, 0.22]);
    
    % right axis
    yyaxis right
    plot(time, v, '--', 'LineWidth', 1.2, 'DisplayName', 'v (Pump)');
    plot(time, d, '-', 'LineWidth', 1.2, 'DisplayName', 'd (Disturbance)');
    ylabel('Flow Rate [m^3/s]');
    set(gca, 'YScale', 'linear');

    grid on;
    xlabel('Time [s]');
    modell_name = out.SimulationMetadata.ModelInfo.ModelName;
    title(sprintf('Simulation Results: %s', modell_name), 'Interpreter', 'none');
    legend('Location', 'best');

    if ~exist('data', 'dir')
        mkdir('data');
    end
    filename = fullfile('data', [modell_name, '.png']);
    saveas(gcf, filename);
end

