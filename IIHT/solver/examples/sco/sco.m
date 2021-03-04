function [out1,out2] = sco(z,data)           
  out1 = data(z,'obj');  % objective function   
  if nargout>1
  out2 = data(z,'grad');  % gradient
  end            
end
