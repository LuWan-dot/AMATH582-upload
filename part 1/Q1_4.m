%%%% Q1.4 Find sparse regression using SINDy and interpolation
clear all; close all; clc;
x1 = [20,20,52,83,64,68,83,12,36,150,110,60,7,10,70,...
    100,92,70,10,11,137,137,18,22,52,83,18,10,9,65];
x2 = [32,50,12,10,13,36,15,12,6,6,65,70,40,9,20,...
    34,45,40,15,15,60,80,26,18,37,50,35,12,12,25];
slices = 30;
t = linspace(0,58,slices);
dt = t(2) - t(1);
r = 2;
dt_new = 0.5;
t_new = 0:dt_new:58;
n = length(t_new);
%%
x1_interp = interp1(t,x1,t_new,'spline').';
x2_interp = interp1(t,x2,t_new,'spline').';
X =[x1_interp(1:end-1) x2_interp(1:end-1)];
fq4 = figure();
subplot(2,1,1)
plot(t,x1,'ro-',t_new,x1_interp,'b*')
title('Interpolation of Lynx')
subplot(2,1,2)
plot(t,x2,'ro-',t_new,x2_interp,'b*')
title('Interpolation of hare')
for j=1:n-1
    x1dot(j) = (x1_interp(j+1)-x1_interp(j))/(dt_new);
    x2dot(j) = (x2_interp(j+1)-x2_interp(j))/(dt_new);
end
dx = [x1dot.' x2dot.'];
%% SINDy
polyorder = 3;
Theta = poolData(X,r,polyorder);
m =size(Theta,2);
lambda = 0.025;
Xi = sparsifyDynamics(Theta,dx,lambda,r)
poolDataLIST({'x','y'},Xi,r,polyorder);
%% reconstraction of data with sparse regression
options = odeset('RelTol',1e-12,'AbsTol',1e-12*ones(1,2));
 Beta(1)= Xi(1,1);
 Beta(2)= Xi(2,1);
 Beta(3)= Xi(1,2);
 Beta(4)= Xi(2,2);
Beta(5)= Xi(2,2);
Beta(6)= Xi(3,2);
[tt,xx]=ode45(@(tt,xx) LV2(tt,xx,Beta),t(1:end-1),[20 32],options);
fq5 = figure();
subplot(2,1,1)
plot(t,x1,'ro-',tt,xx(:,1),'b*-')
title('Sparse regression model of Lynx')
subplot(2,1,2)
plot(t,x2,'ro-',tt,xx(:,2),'b*-')
title('Sparse regression model of hare')