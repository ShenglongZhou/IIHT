function [out1,out2] = logistic_regression(x,data)
% data is a structure containing 
%    (data.A data.At data.b) 
% where data.At = data.A'

    Tx    = find(x);
    m     = length(data.b);   
    if ~isempty(Tx)
    Ax    = data.A(:,Tx)*x(Tx); 
    eAx   = exp(Ax);
    else
    Ax    = zeros(m,1);
    eAx   = ones(m,1);
    end
        
    mu    = 1e-6/m;
    
    if sum(eAx)==Inf 
       Tpos = find(Ax>300); 
       Tneg = setdiff(1:m,Tpos);
       obj  = sum(log(1+eAx(Tneg)))+sum(Ax(Tpos))-sum(data.b.*Ax);                
    else
       obj  = sum(log(1+eAx)-data.b.*Ax); 
    end
    
    out1 = obj/m;                                     %objective function
        
    if nargout>1 
       eXx  = 1./(1+eAx);
       out2 = data.At*((1-data.b-eXx)/m) + mu*x;      %gradien
    end
        
     
end



