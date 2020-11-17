% A simple representation of Hill equation
function H = hill(X,X0,lambda,n)
% H+ 
H1 = ((X/X0)^n)/(1+(X/X0)^n);
% H-
H2 = 1/(1+(X/X0)^n);

% Hill function =  H- plus (lambda)* H+
H = H2 + (lambda)*H1;
% if lambda>=1
%     H=H/lambda;

end