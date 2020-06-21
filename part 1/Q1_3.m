%%%% Q1.3 Empirical Predator-Prey models such as Lotka-Volterra are commonly 
%%%%used to models such phenomenon. Consider the model 
%%%%x ? = (b ? py)x and y ? = (rx ? d)y. Use the data to fit values of b, p, r and d.
clear all; close all; clc;
%%%%data x1--Snowshoe Hare   x2----Canada Lynx
x1 = [20,20,52,83,64,68,83,12,36,150,110,60,7,10,70,...
    100,92,70,10,11,137,137,18,22,52,83,18,10,9,65];
x2 = [32,50,12,10,13,36,15,12,6,6,65,70,40,9,20,...
    34,45,40,15,15,60,80,26,18,37,50,35,12,12,25];
slices = 30;
t = linspace(0,58,slices);
dt = t(2) - t(1);
X =[x1;x2];
y0 = [20 30];
%%%% define variable for the solution b, p, r and d.
r = optimvar('r',4,'LowerBound',0.1,"UpperBound",15);
%%%%convert the function to an optimization expression
myfcn = fcn2optimexpr(@RtoODE,r,t,y0);
%%%%Express the objective function as the sum of squared differences 
%%%%between the ODE solution and the solution with true parameters
obj = sum(sum((myfcn-X).^2));
%%%%Create an optimization problem with the objective function
prob = optimproblem("Objective",obj);
%%%%View the problem by calling show.
show(prob)
%%%%Give the initial guess $r0$ for the solver 
%r0.r = [0.3 0.3 0.1 0.3];
r0.r = [7 0.3 0.1 0.3];

[rsol,sumsq] = solve(prob,r0);

disp(rsol.r)
%disp(true)

%%%%Use the solution to reconstruct the data and compare with original data
b = rsol.r(1);
p = rsol.r(2);
r = rsol.r(3);
d = rsol.r(4);
LV = @(t,x)([ b * x(1)-p * x(1)*x(2)       ; ...
                   r * x(1)*x(2)- d *x(2); ]); 
               
[t,y] = ode45(LV,t,[20,30]);
%%
figure;
subplot(2,1,1)
plot(t,x1,'ro-',t,y(:,1),'b*--')
legend('Hare','DMD Hare');
title('Q3 Hare Comparison')
grid on

subplot(2,1,2)
plot(t,x2,'ro-',t,y(:,2),'b*--')
legend('Lynx','DMD Lynx');
title('Q3 Lynx Comparison')
grid on