% demon sparse logistic regression problems with randomly generated data
clc; clear; close all;

n    = 10000;  
m    = ceil(0.25*n); 
s    = ceil(0.05*n);                     
test = 3; 

switch test
  case 1  % Input any data including (data.A, data.At, data.b):
       I0      = randperm(n); 
       Tx      = I0(1:s);
       x       = zeros(n,1);
       x(Tx)   = randn(s,1);
       data.A  = randn(m,n); 
       data.At = data.A';
       q       = 1./(1+exp(-data.A(:,Tx)*x(Tx)));
       data.b  = zeros(m,1);
       for i   = 1:m  
           data.b(i) = randsrc(1,1,[0 1; 1-q(i) q(i)]); 
       end 
       
  case 2 % Input data from our data generation function 
       ExMat = 1;
       MatType = {'Indipendent','Correlated'};
       data    = logistic_random_data(MatType{ExMat},m,n,s,0.5);
       
  case 3 % Input real data including (data.A, data.At, data.b):
       prob      = 'newsgroup'; %'colon-cancer'
       measure   = load(strcat(prob,'.mat')); 
       label     = load(strcat(prob,'_label.mat'));   
       label.b(label.b==-1)= 0;
       [m,n]     = size(measure.A);

       data.A    = normalization(measure.A,1+(m>=1e3)); 
       data.At   = data.A';
       data.b    = label.b; 
       s         = ceil(0.01*m);
end
   
fun      = str2func('logistic_regression');
func     = @(x)fun(x,data);
pars.tol = 1e-6*sqrt(n);  
out      = IIHT(n,s,func,pars); 

fprintf('\n Sample size:   %4dx%4d\n', m,n);
fprintf(' CPU time:      %.3fsec\n',  out.time);
fprintf(' Logistic Loss: %5.2e\n\n', out.obj);
