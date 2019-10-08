% demon sparse logistic regression problems with real data
clc; close all; clear;

prob      = 'newsgroup'; %'colon-cancer'
measure   = load(strcat(prob,'.mat')); 
label     = load(strcat(prob,'_label.mat'));   
label.b(label.b==-1)= 0;
[m,n]     = size(measure.A);

data.A    = normalization(measure.A,1+(m>=1e3)); 
data.At   = data.A';
data.b    = label.b; 
s         = ceil(0.01*m);

fun       = str2func('logistic_regression');
func      = @(x)fun(x,data); 
pars.tol  = 1e-6*sqrt(n);
clear data; 
out       = IIHT(n,s,func,pars)
