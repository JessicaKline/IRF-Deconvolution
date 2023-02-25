function [] = Deconvolution_main(signal, IRF, selec, step_size, xmax)
    % step size, xmax in ns
    %selec == 1 --> double exp decay any other number fits for rise & decay
    %set bounds for fitting on lines 27/28
    if selec == 1 %double and single exponential decays
        
         %Lining up the IRF and decay signals
         signal = signal/max(signal);  
         IRF = IRF/max(IRF);
         [~,r] = max(IRF);
         i = find(abs(IRF(r) - signal) < 0.05);
         for n = i(1)-1:-1:1
             signal(n) = [];
         end
         for n = r:-1:1
             IRF(n) = [];
         end
         mult = signal(1);
         
         %fitting/choosing best convolved function to the data
         %alpha = weight of each components tau_1(short) and tau_2(long)
         %zmult used to line up convolved function and data
         ft = fittype('DoubleExpDecay(x, IRF, tau_1, tau_2, alpha, step_size, zmult)', 'problem', 'IRF');
         ft0 = fitoptions(ft);
         
         %CHANGE VALUES HERE FOR FIT PARAMETERS WHEN NECESSARY
         ft0.Lower = [0.2  step_size 3 0.1 mult];  %adjust values on lines 24 & 25 for fine control over fitting
         ft0.Upper = [1  step_size 6.5 1.8 mult];  %[alpha, step_size, tau1, tau2, zmult];
         
         
         ft0.MaxIter = 9000000;
         ft0.StartPoint = [.8 step_size 20 200 mult];
         t = 0:step_size:step_size*(length(signal)-1);
         t = t';
         [myfit,accuracy] = fit(t,signal, ft, ft0, 'problem', IRF);
         
         % displaying and calculating parameters for plot output
         coeff = coeffvalues(myfit);
         conf = confint(myfit);
         format short;
         m = abs(coeff(3) - conf(1,3));
         j = abs(coeff(4) - conf(1,4));
         k = abs(coeff(1) - conf(1,1));
         disp(['alpha: ' num2str(coeff(1)) sprintf('  \t') num2str(k)]);
         disp(['tau1:  ' num2str(coeff(3)) sprintf(' \t') num2str(m)]);
         disp(['tau2:  '  num2str(coeff(4)) sprintf('\t') num2str(j)]);
         disp(' ');
         disp(['R Squared:    ' num2str(accuracy.rsquare)]);
         disp(['Stnd. Err.:   ' num2str(accuracy.rmse)]);
         conv_signal = myfit(t);
         deconv_signal = coeff(1).*exp(-t./coeff(3)) + (1-coeff(1)).*exp(-t./coeff(4));
         deconv_signal = deconv_signal/max(deconv_signal);
    else % exponential rise and decay
        
         %lining up curves
         signal = signal/max(signal);
         IRF = IRF/max(IRF);        
         while signal(1) < 0.15
            signal(1) = [];
         end
         while IRF(1) < 0.15
            IRF(1) = [];
         end
         avg = 0;
         [~,r] = max(signal);
         for z = r-2:r+2            %adjust values on lines 63 & 66 if peak heights are off
             avg = avg+signal(z);
         end
         avg = avg/5;
         
         for n = length(IRF):-1:length(signal)+1
            IRF(n) = [];
         end
        
         %fitting/choosing best convolved function to the data
         ft = fittype('ExpRiseAndDecay(x, IRF, tau_rise, tau_decay, alpha, step_size, average)', 'problem', 'IRF');
         ft0 = fitoptions(ft);
         
         %CHANGE VALUES HERE FOR FIT PARAMETERS WHEN NECESSARY
         ft0.Lower = [0 avg  step_size 400 10];         %adjust the values on lines 77 & 78 for fine control over fitting
         ft0.Upper = [1 avg  step_size 4000 1000];      %[alpha, average, step_size, tau_decay, tau_rise]
         
         
         ft0.MaxIter = 9000000;
         ft0.StartPoint = [0 avg step_size 500 50];
         t = 0:step_size:step_size*(length(signal)-1);
         [myfit, accuracy] = fit(t',signal, ft, ft0, 'problem', IRF);
         
         % displaying and calculating parameters for plot output
         coeff = coeffvalues(myfit);
         conf = confint(myfit);
         format short;
         m = abs(coeff(5) - conf(1,5));
         j = abs(coeff(4) - conf(1,4));
         disp(['tau_rise:  ' num2str(coeff(5)) sprintf(' \t') num2str(m)]);
         disp(['tau_decay:  '  num2str(coeff(4)) sprintf('\t') num2str(j)]);
         disp(' ');
         disp(['R Squared:    ' num2str(accuracy.rsquare)]);
         disp(['Stnd. Err.:   ' num2str(accuracy.rmse)]);
         conv_signal = myfit(t);
         deconv_signal = -1*exp(-t./coeff(5)) + (1+coeff(1)).*exp(-t./coeff(4));
         deconv_signal = avg*deconv_signal/max(deconv_signal);
         while deconv_signal(1) < 0.15
            deconv_signal(1) = [];
         end
         for n = length(deconv_signal)+1:1:length(t)
             deconv_signal(n) = 0;
         end
    end
    
    %send to plotting
    resid_line = signal - conv_signal; 
    outputPlot(deconv_signal, conv_signal, signal, resid_line, xmax, step_size);
end

