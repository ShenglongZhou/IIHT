% demon a general sparsity constrained problem
%     min    x'*[6 5;5 8]*x+[1 9]*x-sqrt(x'*x+1)  
%     s.t. \|x\|_0<=s
% where s=1
% 
clc; clear; close all;

n    = 2;    
s    = 1;
% you can find this function in 'examples'-->'general_sco'
data     = @(var,flag)simple_ex4_func(var,flag);  

fun      = str2func('general_example');
func     = @(x)fun(x,data);  
out      = IIHT(n,s,func); 
fprintf('\nProblem dimension: n=%d\n', n);
fprintf('CPU time:         %6.3fsec\n',  out.time);
fprintf('Objective value:  %5.2e\n\n', out.obj);



 