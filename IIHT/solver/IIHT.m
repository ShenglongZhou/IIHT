function out = IIHT(n,s, func, pars)
% A solver for sparsity constraints models:
%
%                    min f(x),  s.t. ||x||_0<=s,
%
% where f: R^n->R and s<<n.
%
% Written by 16/01/2016, Shenglong Zhou
%
%
% Inputs:
%     n       : Dimension of the solution x  (required)
%     s       : Sparsity level of the solution x, an integer in (0,n] (required)
%     func    : function handle defines the function f(x) and its gradient             
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
%
%  This solver was created based on the algorithm proposed by  
%  Pan, L., Zhou, S., Xiu, N. & Qi, H.D. (2017). A convergent iterative hard 
%  thresholding for nonnegative sparsity optimization. Pacific Journal of 
%  Optimization, 13(2), 325-353.
%
%%%%%%%    Send your comments and suggestions to                     %%%%%%
%%%%%%%    shenglong.zhou@soton.ac.uk                                %%%%%% 
%%%%%%%    Warning: Accuracy may not be guaranteed!!!!!              %%%%%%
warning off;

if nargin<3; error('Imputs are not enough!\n'); end
if nargin<4; pars=[]; end
if isfield(pars,'iteron');iteron = pars.iteron; else; iteron = 1;        end
if isfield(pars,'maxit'); maxit  = pars.maxit;  else; maxit  = 5e3;      end
if isfield(pars,'tol');   tol    = pars.tol;    else; tol = 1e-6*sqrt(n);end  

t0     = tic;
sigma0 = 1e-4;
x      = zeros(n,1);
xo     = zeros(n,1);

% main body
if iteron 
fprintf(' Start to run the sover...\n'); 
fprintf('\n Iter    Error        f(x)       Time \n'); 
fprintf('---------------------------------------\n');
end
[f,g]    = func(x);
scale    = (max(f,norm(g))>n); 
scal     = n*(scale==1)+(scale==0); 
fs       = f/scal;  
gs       = g/scal;  
for iter = 1:maxit     
    
    x_old  = x;
      
    % Line search for setp size alpha
    fx_old = fs;
    alpha  = sqrt(iter);
    for j  = 1:10
        [mx,T] = maxk(x_old-alpha*gs,s,'ComparisonMethod','abs');
        x      = xo; 
        x(T)   = mx;
        fs     = func(x)/scal;
        if (fs < fx_old-.5*sigma0*sum((x-x_old).^2)); break; end
        alpha  = alpha/2;        
    end
    [f,g]  = func(x);
    fs     = f/scal;  
    gs     = g/scal;  
    
    % Stop criteria 
	residual = scal*norm(gs(T))/max(1,norm(mx)); 
    if iteron && mod(iter,1)==0
       fprintf('%4d    %5.2e    %5.2e   %5.2fsec\n',iter,residual,fs*scal,toc(t0)); 
    end
 
	if residual<tol || abs(fs-fx_old)<1e-10*(1+abs(fs))  
       break; 
    end  

end

if iteron
fprintf('---------------------------------------\n');
end

out.x    = x;
out.obj  = fs*scal;
out.iter = iter;
out.time = toc(t0);
out.error= residual;
out.normg= norm(g)*scal;
if  out.normg<1e-5 && iteron
    fprintf(' A global optimal solution might be found\n');
    fprintf(' because of ||g(x)||=%5.2e!\n',out.normg);  
end
end
