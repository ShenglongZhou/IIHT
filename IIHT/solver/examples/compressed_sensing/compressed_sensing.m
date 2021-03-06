function [out1,out2] = compressed_sensing(x,data)    
% data is a structure containing 
%    (data.A data.At data.b) 
% where data.At = data.A'    
    if  isa(data.A, 'function_handle')  
        Axb  = data.A(x)-data.b;
    else
        Tx   = find(x);
        if ~isempty(Tx)
        Axb  = data.A(:,Tx)*x(Tx)-data.b;
        else
        Axb  =  -data.b;
        end
    end
    
    out1 = sum(Axb.*Axb)/2; % objective function 
    
    if  nargout>1 
        if  isa(data.At, 'function_handle')  
            out2 = data.At(Axb);     % gradien  
        else
            out2 = data.At*Axb;      % gradien      
        end
    end

end
