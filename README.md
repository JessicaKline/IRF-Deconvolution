# IRF-Deconvolution
Separate signal and IRF from PL Lifetime data using reconvolution methodology


Deconvolution_Main expects:
signal: y-axis counts/bin from lifetime data
IRF: y-axis counts/bin from IRF of system
selec: type of fitting you want to do
    1 - biexponential decay
    2 - exponetial rise and decay
step_size: bin size of TCSPC counter card in ns
x_max: maximum x-axis plotting value in ns
