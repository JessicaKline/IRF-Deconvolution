function y = ExpRiseAndDecay(x, IRF, tau_1, tau_2, alpha, step_size, avg)
    t = 0:step_size:(length(x)-1)*step_size;
    t = t';
    theory = -1*exp(-t./tau_1) + (1+alpha)*exp(-t./tau_2);
%             t = 0;
%             for n = -20:length(x)
%                 l = -1*exp(-t/tau_1)+(1+alpha)*exp(-t/tau_2);
%                 if(l < 0) 
%                     l = 0;
%                 end
%                 theory(n+1-(-20),1) = l;
%                 t = t+step_size;
% 
%             end
    %theory = NoZeros(theory);
    theory = theory/max(theory);
    y = conv(theory, IRF);
    y = avg*y/max(y);
    y = NoZeros(y);
    %y = removeNAN(y);
    for n = length(y):-1:length(x)+1
        y(n) = [];
    end
%     plot(t, x);
%     hold on;
%     plot(t, y);
end

