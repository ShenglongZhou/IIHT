% demon compressed sensing problems 
clc; clear; close all;

n       = 10000;  
m       = ceil(n/4); 
s       = ceil(0.01*n); 
test    = 1; 

switch test
  case 1  % Input any data including (data.A, data.At, data.b) 
       I         = randperm(n); 
       Tx        = I(1:s);
       x         = zeros(n,1);  
       x(Tx)     = randn(s,1);
       data.xopt = x;
       data.A    = randn(m,n);
       data.At   = data.A';
       data.b    = data.A(:,Tx)*data.xopt(Tx);  
  case 2 % Input data from our data generation function
       ExMat   = 1;
       MatType = {'GaussianMat','PartialDCTMat'}; 
       data    = compressed_sensing_data(MatType{ExMat}, m,n,s,0);
end
 
pars.tol = 1e-6*sqrt(n);
out      = IIHT('CS',n,s,data,pars); 

fprintf(' CPU time:          %.3fsec\n',  out.time);
fprintf(' Objective:         %5.2e\n',  out.obj);
fprintf(' Sample size:       %dx%d\n', m,n);
if isfield(data,'xopt') && s<=100
   ReoveryShow(data.xopt,out.x,[1000, 550, 400 200],1)
end
