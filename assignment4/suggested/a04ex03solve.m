function [errors, EOCp] = a04ex03solve(i)
% Assignment 4, Programming exercise 3, Sample solution
% Compute the errors of the FDM solution for Poisson eq
% on the domain (0,1)^2 with N = 2^p - 1 interior 
% points in each direction using a five point stencil. Here
% p runs from 2 to 9.
%
%       [    -1    ]
% 1/h^2 [ -1 +4 -1 ]
%       [    -1    ]
%
% Note:
%   i determines the problem to solve
%
%   errors is a vector of length 8 containing the discretization errors
%
% Example:
%       errors = a04ex03solve(p,i);

% determine exact solution corresponding to i
if i == 1
    u = @(x,y) x.*y - x.*y.^3 - x.^3.*y + x.^3.*y.^3 ;
else
    u = @(x,y) sin(3.*pi*x).*sin(pi*y);
end
Nsteps = 8;
errors = zeros(1,Nsteps);
steps = zeros(1,Nsteps);

for p = 2:Nsteps+1
    N = 2^p - 1;
    h = 1/(N+1);
    steps(p-1) = h;
    % evaluate u and transform into lexicographically ordered vector
    [xh,yh]=meshgrid(linspace(h,1-h,N)); % create mesh using MATLABs meshgrid
    u_eval = u(xh,yh);
    % transform into lexicographically ordered vector
    u_eval = reshape(u_eval',N^2,1);
    
    % get the matrix vector system for problem i with step size N = 2^p-1
    [Lh, fh] = a04ex03getPDE(p,i);
    
    uh = Lh\fh;
        
    errors(p-1) = norm(u_eval - uh, Inf);
end
   
loglog(steps,errors)    
    
EOCp = (log(errors(2:Nsteps)) - log(errors(1:Nsteps-1)))./...
        (log(steps(2:Nsteps)) - log(steps(1:Nsteps-1)));

