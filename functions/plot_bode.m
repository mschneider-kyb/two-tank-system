function plot_bode(sys_tf, w, title_str, filename_str)
    h = figure('Visible', 'on'); 
    [Gm, Pm, Wcg, Wcp] = margin(sys_tf); 
    margin(sys_tf, w);
    grid on;

    % Title with stability margins in dB and degrees
    customTitle = sprintf('%s\n(A_m = %.2f dB at %.2f rad/s, \\Phi_m = %.2f deg at %.2f rad/s)', ...
    title_str, 20*log10(Gm), Wcg, Pm, Wcp);
    title(customTitle);
    
    if ~exist('data', 'dir'), mkdir('data'); end
    print(h, fullfile('data', filename_str), '-dpng', '-r300'); 
end
