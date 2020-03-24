function [out1,out2] = compressed_sensing(x,data)    

     x  = find(x);

    if ~isempty(Tx)   
    Axb  = data.A(:,Tx)*x(Tx)-data.b;
    else
    Axb  =  -data.b;
    end

    out1 = sum(Axb.*Axb)/2;                %objective function 
    
    if  nargout>1 
    out2 = data.At*Axb;                    %gradien          
    end

end


