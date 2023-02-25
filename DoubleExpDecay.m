function y = DoubleExpDecay(x, IRF, tau_1, tau_2, alpha, step_size, zmult)
    %set up times
    t = 0:step_size:(length(x)-1)*step_size;
    t = t';
    
    %create theoretical decay
    theory = alpha.*exp(-t./tau_1) + (1-alpha).*exp(-t./tau_2);
    theory = theory/max(theory);
    
    %convolve theory and IRF
    y = conv(IRF, theory);
    y = y/max(y);
    
    %make sure convolved trace is the same length and at the same place in
    %time as the real trace
    %i = find(abs(y - zmult) <= 0.02);
    i = find(y == 1);
    if ~isempty(i)
        for n = 1:i(1)-1
            y(1) = [];
        end
    end
    if length(x) > length(y)
        y(length(x)) = 0;
    end
    %y = TimeZero(y,1);
    for n = length(y):-1:length(x)+1
        y(n) = [];
    end
end

