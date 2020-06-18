clc; clear; close all;

Test    = 1; %= 1, 2, 3, 4 or 5                          
ExMat   = 1; %= 1 or 2

n       = 1000;  
m       = ceil(0.25*n); 
s       = ceil(0.05*n);
if Test > 3
n       = 2; 
s       = 1;
end   
    
switch Test
    
    case 1 % demon compressed sensing problems
    MatType = {'GaussianMat','PartialDCTMat'}; 
    data    = compressed_sensing_data(MatType{ExMat}, m,n,s,0);
    FuncNam = 'compressed_sensing';
    
    case 2 % demon sparse logistic regression problems
    MatType = {'Indipendent','Correlated'};
    rho     = 0.5; % 0<= rho <=1 it is useful for 'Correlated' data
    data    = logistic_random_data(MatType{ExMat},m,n,s,rho);
    FuncNam = 'logistic_regression';   
    
    case 3 % demon sparse linear complementarity problem
    MatType = {'LC-zmat','LC-sdp','LC-sdp-non'};
    data    =  LCPdata(MatType{ExMat},n, s);
    FuncNam = 'LCPfunc'; 
    
    case 4 % demon a simple example 
    a       = 0.1*randn; b=0.1*rand(n,1);
    data    = @(var,flag)simple_ex2_func(var,flag, a, b);
    FuncNam = 'general_example'; 
    
    case 5 % demon a simple example 
    data    = @(var,flag)simple_ex3_func(var,flag);
    FuncNam = 'general_example'; 
end
 
pars.tol = 1e-6*sqrt(n);
fun      = str2func(FuncNam);
func     = @(x)fun(x,data);  
out      = IIHT(n,s,func,pars);
fprintf('\n Variable size:     n = %d\n', n);
fprintf(' Recovery time:     %.3fsec\n',  out.time);
fprintf(' Objective value:   %5.2e\n', out.obj); 
