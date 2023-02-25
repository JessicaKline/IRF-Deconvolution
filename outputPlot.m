function [] = outputPlot(deconv_signal, conv_signal, signal, resid_line, xmax, step_size)
    %create x-axis
    t = 0:step_size:(length(signal) - 1)*step_size;
    t = t';
    %t = t/1000;
    %xmax = xmax/1000;
    
    
    %plotting colors
    co = [         0    0.4470    0.7410
    0.9290    0.6940    0.1250
    0.8500    0.3250    0.0980
    0.4940    0.1840    0.5560
    0    0    0
    0.3010    0.7450    0.9330
    0.6350    0.0780    0.1840];
    set(groot,'defaultAxesColorOrder',co)
    m = round((max(abs(resid_line)))*100)/100;
    
    %plot residual
    subplot(75,1,[1,10]);
    scatter(t, resid_line, 2.5, [0.4940    0.1840    0.5560]);
    box on;
    xlim([0 xmax]);
    ylim([-m-.02, m+.02]); %scales residual plot to max abs deviation from zero
    yticks([-m 0 m]);
    set(gca,'xtick',[], 'FontSize', 12, 'FontWeight', 'bold','LineWidth',1.5)
    
    %plot signal, deconv and returned convolved signal
    subplot(75, 1,[11,75]);
    plot(t, deconv_signal, 'LineWidth', 2.5);   %theoretical
    hold on;
    plot(t, signal, 'LineWidth', 3.5);          %data
    plot(t, conv_signal, 'LineWidth', 2.5);     %fit to data
    resid_line = resid_line+2;
    scatter(t, resid_line, 2.5);
    set(gca, 'FontSize', 13, 'FontWeight', 'bold', 'LineWidth', 1.5);
    xlabel('Time (ns)', 'FontWeight', 'bold', 'FontSize', 16);
    ylabel('Counts (au)','FontWeight', 'bold', 'FontSize', 16);
    xlim([0 xmax]);
    ylim([0 1.03]);
    legend({'theoretical', 'signal', 'convolved', 'residual'}, 'Location', 'northeast');
    hold off;
end

