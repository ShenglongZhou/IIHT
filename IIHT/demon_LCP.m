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
       MatType  = {'z-mat','sdp','sdp-non'};
       data     =  LCPdata(MatType{ExMat},n, s);
end

pars.neg = 1;
out      = IIHT('LCP',n,s,data,pars); 

fprintf(' CPU time:          %.3fsec\n',  out.time);
fprintf(' Objective:         %5.2e\n',  out.obj);
fprintf(' Sample size:       %dx%d\n', m,n);
if  isfield(data,'xopt')
    RecoverShow(data.xopt,out.x,[900,500,500,250],1);
end
