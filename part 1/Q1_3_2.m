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
X1 = X(:,1:end-1);
X2 = X(:,2:end);
r = 2;
X_q3 = [x1;x2;x1.*x2;x2.*x1.^2;x1.*x2.^2;x1.^3.*x2;x2.*x1.^3;...
    x1.^2.*x2.^2;x1.*x2.^4;x1.^2.*x2.^3;x1.^3.*x2.^2;x1.^4.*x2.^1;];
%X_q3 = [x1;x2;x1.*x2;x2.*x1.^2;x1.*x2.^2;x1.^3.*x2;x2.*x1.^3;x1.^2.*x2.^2];
X1_q3 = X_q3(:,1:end-1);
X2_q3 = X_q3(:,2:end);

r_q3 = 11;

[Phi_q3,omega_q3,lambda_q3,b_q3,Xdmd_q3,S_q3] = DMD2(X1_q3,X2_q3,r_q3,t);

fq3 = figure;
subplot(2,2,1)
plot(t,x1,'ro-',t,abs(Xdmd_q3(1,:)),'b*--')
legend('Hare','DMD Hare');
title('Q3 Hare Comparison')
grid on

subplot(2,2,2)
plot(t,x2,'ro-',t,abs(Xdmd_q3(2,:)),'b*--')
legend('Lynx','DMD Lynx');
title('Q3 Lynx Comparison')
grid on

subplot(2,2,3);
semilogy(abs(diag(S_q3)),'ko');
title('Sigma')
grid on

subplot(2,2,4)
plot(omega_q3,'ko')
title('Omega')
xlabel('Real')
ylabel('Imagine')
grid on