clear all; close all; clc;

%%%%data x1--Snowshoe Hare   x2----Canada Lynx
x1 = [20,20,52,83,64,68,83,12,36,150,110,60,7,10,70,...
    100,92,70,10,11,137,137,18,22,52,83,18,10,9,65];
x2 = [32,50,12,10,13,36,15,12,6,6,65,70,40,9,20,...
    34,45,40,15,15,60,80,26,18,37,50,35,12,12,25];

slices = 30;
t = linspace(0,58,slices);
dt = t(2) - t(1);

r = 2;

%%%%%% SINDy with interpolation
% dt_new = 0.5;
% t_new = 0:dt_new:58;
n = length(t);
%%
%x1_interp = interp1(t,x1,t_new,'linear').';
%x2_interp = interp1(t,x2,t_new,'linear').';
%X =[x1_interp(1:end-1) x2_interp(1:end-1)];
X = [x1(1:end-1).' x2(1:end-1).'];
% fq4 = figure();
% subplot(2,1,1)
% plot(t,x1,'ro-',t_new,x1_interp,'b*')
% title('Interpolation of Lynx')
% subplot(2,1,2)
% plot(t,x2,'ro-',t_new,x2_interp,'b*')
% title('Interpolation of hare')

for j=1:n-1
    x1dot(j) = (x1(j+1)-x1(j))/(dt);
    x2dot(j) = (x2(j+1)-x2(j))/(dt);
end

dx = [x1dot.' x2dot.'];
%%
polyorder = 3;
Theta = poolData(X,r,polyorder);
m =size(Theta,2);
%%
lambda = 0.025;
Xi = sparsifyDynamics(Theta,dx,lambda,r)
poolDataLIST({'x','y'},Xi,r,polyorder);

%%
options = odeset('RelTol',1e-12,'AbsTol',1e-12*ones(1,2));
 Beta(1)= Xi(1,1);
 Beta(2)= Xi(2,1);
 Beta(3)= Xi(1,2);
 Beta(4)= Xi(2,2);
Beta(5)= Xi(2,2);
Beta(6)= Xi(3,2);

[tt,xx]=ode45(@(tt,xx) LV2(tt,xx,Beta),t(1:end-1),[20 32],options);
%%
fq5 = figure();
subplot(2,1,1)
plot(t,x1,'ro-',tt,xx(:,1),'b*-')
title('Interpolation of Lynx')
subplot(2,1,2)
plot(t,x2,'ro-',tt,xx(:,2),'b*-')
title('Interpolation of hare')