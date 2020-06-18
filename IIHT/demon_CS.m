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
  case 3 % Input a real data including (data.A, data.At, data.b) 
       load 'DrivFace.mat'; load 'nlab.mat';   %'identity.mat';
       [m,n]     = size(A);
       s         = ceil(0.01*n);
       scale     = svds(A,1);
       data.A    = A/scale; 
       data.b    = y/scale; 
       data.At   = data.A'; 
end


fun      = str2func('compressed_sensing');
func     = @(x)fun(x,data);  
pars.tol = 1e-6*sqrt(n);
out      = IIHT(n,s,func,pars); 

fprintf('\n Sample size:       %dx%d\n', m,n);
fprintf(' Recovery time:     %.3fsec\n',  out.time);
fprintf(' Objective value:   %5.2e\n', out.obj);
if isfield(data,'xopt')
fprintf(' Recovery accuracy: %5.2e\n\n', ...
norm(out.x-data.xopt)/norm(data.xopt));
end
