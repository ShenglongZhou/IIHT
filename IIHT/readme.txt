To implement this solver, please 

[1] run startup.m first to add the path;
[2] run demonXXXX.m to solve  different problems

This source code contains the algorithm described in:

Pan, L., Zhou, S., Xiu, N. & Qi, H.D. (2017). 
A convergent iterative hard thresholding for nonnegative sparsity optimization. 
Pacific Journal of  Optimization, 13(2), 325-353.

Please give credits to this paper if you use the code for your research.

% ===================================================================
% The citation of the solver IIHT takes the form of
%               
%                out = IIHT(problem,n,s,data, pars)
% 
% It  aims at solving the sparsity constrained optimization with form
%
%         min_{x\in R^n} f(x)  s.t.  \|x\|_0<=s
%
% where s is the given sparsity, which is << n.  
%
% Inputs:
%     problem:  A text string for different problems to be solved, (required)
%               = 'CS',  compressed sensing problems
%               = 'LCP', linear complementarity problems
%               = 'LR',  sparse logistic regression problems
%               = 'SCO', other sparsity constrained optimization problems
%     data    : A triple structure (data.A, data.At, data.b) (required)
%               data.A, the measurement matrix, or a function handle @(x)A(x);
%               data.At = data.A',or a function handle @(x)At(x);
%               data.b, the observation vector 
%     n       : Dimension of the solution x, (required)
%     s       : Sparsity level of x, an integer between 1 and n-1, (required)                     
%     pars:     Parameters are all OPTIONAL
%               pars.iteron --  =1. Results will  be shown for each iteration (default)
%                               =0. Results won't be shown for each iteration 
%               pars.maxit  --  Maximum nonumber of iteration   (default 5000) 
%               pars.tol    --  Tolerance of stopping criteria  (default 1e-6sqrt(n)) 
%
% Outputs:
%     out.x:             The sparse solution x 
%     out.obj:           f(x)
%     out.time           CPU time
%     out.iter:          Number of iterations
%     out.error:         error ||g(x~=0)||
%     out.normg:         ||g||


% Here are some examples that you can run
% =================================================================
% Example I:  compressed sensing problem

n         = 2000; 
m         = ceil(0.25*n);
s         = ceil(0.01*n);     
x         = zeros(n,1);
I         = randperm(n); 
I         = I(1:s);
x(I)      = randn(s,1);
data.A    = randn(m,n)/sqrt(n);
data.At   = data.A';
data.b    = data.A(:,I)*x(I);
out       = IIHT('CS',n,s,data);
ReoveryShow(out.x,x,[900,500,500,250],1)

% =================================================================
% Example II:  linear complementarity problem 

n         = 2000; 
s         = ceil(0.01*n);     
x         = zeros(n,1);
I         = randperm(n); 
T         = I(1:s);
x(T)      = rand(s,1);
M         = randn(n,ceil(n/4));
data.M    = M*M'/n;  
data.Mt   = data.M';
Mx        = data.M(:,T)*x(T);
data.q    = abs(Mx); 
data.q(T) = -Mx(T); 
out       = IIHT('LCP',n,s,data);
ReoveryShow(out.x,x,[900,500,500,250],1)

% =================================================================
% Example III:  Logistic regression problem

n         = 2000; 
m         = ceil(0.25*n);
s         = ceil(0.05*n);     
I         = randperm(n);
T         = I(1:s); 
data.A    = randn(m,n); 
data.At   = data.A'; 
q         = 1./(1+exp(-data.A(:,T)*randn(s,1)));
data.b    = zeros(m,1);
for i     = 1:m    
data.b(i) = randsrc(1,1,[0 1; 1-q(i) q(i)]);
end               
out       = IIHT('LR',n,s,data) 

