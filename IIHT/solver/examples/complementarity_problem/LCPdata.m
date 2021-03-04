function data = LCPdata( example, n,s)
switch example
    case 'LC-zmat'
         M       = speye(n)-1/n;
         q       = ones(n,1)/n; 
         q(1)    = 1/n-1;
         xopt    = zeros(n,1); 
         xopt(1) = 1;
         Mt      = M;
    case 'LC-sdp'
         Z       = randn(n,ceil(n/2));
         M       = Z*Z';
         [xopt,T]= getsparsex(n,s); 
         Mx      = M(:,T)*xopt(T);
         q       = abs(Mx);
         q(T)    = -Mx(T); 
         Mt      = M;
         M=M/n;  Mt=Mt/n; q=q/n;
    case 'LC-sdp-non'
         Z       = rand(n,ceil(n/2));
         M       = Z*Z';
         [xopt,T]= getsparsex(n,s); 
         q       = rand(n,1);
         q(T)    = -q(T); 
         M=M/n;  Mt=M; q=q/n;        
end
    
data.M    = M;
data.Mt   = Mt;
data.q    = q;
data.n    = n;
data.xopt = xopt;
end


function [x,T]= getsparsex(n,s)
         I       = randperm(n); 
         T       = I(1:s); 
         x       = zeros(n,1); 
         x(T)    = 0.1+abs(randn(s,1));
end
