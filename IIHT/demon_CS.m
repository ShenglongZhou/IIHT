% demon compressed sensing problems with randomly generated data
clc; clear; close all;

n       = 2000;  
m       = ceil(n/4); 
s       = ceil(0.01*n);                      
 
% % You could input any data including (data.A, data.At, data.b) 
I         = randperm(n); 
Tx        = I(1:s);
x         = zeros(n,1);  
x(Tx)     = randn(s,1);
data.xopt = x;
data.A    = randn(m,n);
data.At   = data.A';
data.b    = data.A(:,Tx)*data.xopt(Tx);  

% Or you could input data from our data generation function
% ExMat = 1;
% MatType = {'GaussianMat','PartialDCTMat'}; 
% data    = compressed_sensing_data(MatType{ExMat}, m,n,s,0);


fun      = str2func('compressed_sensing');
func     = @(x)fun(x,data);  
pars.tol = 1e-6*sqrt(n);
out      = IIHT(n,s,func,pars); 

fprintf('\n Sample size:       m=%d, n=%d\n', m,n);
fprintf(' Recovery time:    %6.3fsec\n',  out.time);
if isfield(data,'xopt')
fprintf(' Recovery accuracy: %5.2e\n\n', ...
norm(out.x-data.xopt)/norm(data.xopt));
end