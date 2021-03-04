function [out1,out2] = lcp(x,data)
% data is a structure containing 
%    (data.M data.Mt data.b) 
% where data.Mt = data.M'    

    M   = data.M;
    Mt  = data.Mt;
    q   = data.q;
    r   = 2;
    if isfield(data,'r'); r = data.r; end    
    
    clear data; 
    
    eps =  0;
    ip  = find(x>eps);
    in  = find(x<-eps);
    ix  = union(ip,in); 
    
    Mx  = M(:,ix)*x(ix) + q;    
 
    tp  = find(Mx>eps); 
    tn  = find(Mx<-eps);
    tt  = intersect(ip,tp);  
    Mxn = abs(Mx(tn));    
    xn  = abs(x(in)); 

    %objective function 
    out1 = ( sum( ( x(tt).* Mx(tt) ).^r )+ sum(xn.^r) + sum(Mxn.^r) )/r ;                 
    
    %gradient
    if  nargout>1 
    out2     = Mt(:,tt)*( x(tt).^r.*(Mx(tt).^(r-1)) )- Mt(:,tn)* ( Mxn.^(r-1) );
    out2(tt) = out2(tt) + ( x(tt).^(r-1) ).*( Mx(tt).^r ); 
    out2(in) = out2(in) - xn.^(r-1) ; 
    end
        
end


