% demon compressed sensing problems with real data
clc; clear; close all;

load 'DrivFace.mat';
load 'nlab.mat';   %'identity.mat';

[m,n]     = size(A);
s         = 10;
data.A    = A/sqrt(n); 
data.b    = y/sqrt(n); 
data.At   = data.A'/sqrt(n); 

fun      = str2func('compressed_sensing');
pars.tol = 1e-6*sqrt(n);
func     = @(x)fun(x,data);  
out      = IIHT(n,s,func,pars); 

fprintf('\nSample size:       m=%4d, n=%4d\n', m,n);
fprintf('CPU time:          %5.3fsec\n',  out.time);
fprintf('Objective value:   %5.3e\n\n', out.obj);

 
