% demon linear complementarity problem with randomly generated data
clc; clear; close all;

n      = 10000;  
m      = ceil(n/4); 
s      = ceil(0.01*n);                      
test   = 2;

switch test
  case 1  % Input any data including (data.M, data.Mt, data.q)
       I      = randperm(n); 
       Tx     = I(1:s);
       Z      = rand(n,ceil(n/2));
       M      = Z*Z';
       q      = rand(n,1);
       q(Tx)  = -q(Tx); 
       data.M = M;  data.Mt=M; data.q=q; 
  case 2 % Input data from our data generation function
       ExMat    = 2;
       MatType  = {'LC-zmat','LC-sdp','LC-sdp-non'};
       data     =  LCPdata(MatType{ExMat},n, s);
end

fun      = str2func('LCPfunc');
func     = @(x)fun(x,data);  
pars.tol = 1e-6*sqrt(n);
out      = IIHTnew(n,s,func,pars); 

fprintf('\n Sample size:       n = %d\n',n);
fprintf(' Recovery time:    %6.3fsec\n',  out.time);
fprintf(' Objective value:   %5.2e\n', out.obj);
if isfield(data,'xopt')
fprintf(' Recovery accuracy: %5.2e\n', ...
norm(out.x-data.xopt)/norm(data.xopt));
end
