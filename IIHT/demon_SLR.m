% demon sparse logistic regression problems 
clc; clear; close all;

n    = 10000;  
m    = ceil(0.25*n); 
s    = ceil(0.05*n);                     
test = 1; 

switch test
  case 1 % Input data from our data generation function 
       ExMat = 1;
       MatType = {'Indipendent','Correlated'};
       data    = logistic_random_data(MatType{ExMat},m,n,s,0.5);
       
  case 2 % Input real data including (data.A, data.At, data.b):
       prob      = 'colon-cancer';
       measure   = load(strcat(prob,'.mat')); 
       label     = load(strcat(prob,'_label.mat'));   
       label.b(label.b==-1)= 0;
       [m,n]     = size(measure.A);
       data.A    = normalization(measure.A,1+(m>=1e3)); 
       data.At   = data.A';
       data.b    = label.b; 
       s         = ceil(0.01*m);
end
   
pars.tol = 1e-6*sqrt(n);  
out      = IIHT('LR',n,s,data,pars); 

fprintf(' Sample size:       %dx%d\n', m,n);
fprintf(' CPU time:          %.3fsec\n',  out.time);
fprintf(' Logistic Loss:     %5.2e\n\n', out.obj);
