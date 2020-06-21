%%%% Q1.2 Do a time-delay DMD model to produce a forecast and compare with 
%regular DMD. Determine if it is likely that there are latent variables.
clear all; close all; clc;

%%%%data x1--Snowshoe Hare   x2----Canada Lynx
x1 = [20,20,52,83,64,68,83,12,36,150,110,60,7,10,70,...
    100,92,70,10,11,137,137,18,22,52,83,18,10,9,65];
x2 = [32,50,12,10,13,36,15,12,6,6,65,70,40,9,20,...
    34,45,40,15,15,60,80,26,18,37,50,35,12,12,25];

slices = 30;
t = linspace(0,58,slices);
dt = t(2) - t(1);

X1_q2 =[];
X2_q2 =[];
kk = 10;
for j=1:kk
    X1_q2 = [X1_q2;x1(j:29-kk+j);x2(j:29-kk+j)];
    X2_q2 = [X2_q2;x1(j+1:29-kk+j+1);x2(j+1:29-kk+j+1)];
    
end
r_q2 = 18;

[Phi_q2,omega_q2,lambda_q2,b_q2,Xdmd_q2,S_q2] = DMD2(X1_q2,X2_q2,r_q2,t);

fq2 = figure;
subplot(2,2,1)
plot(t,x1,'ro-',t,abs(Xdmd_q2(1,:)),'b*--')
legend('Hare','DMD Hare');
title('Q2 Hare Comparison')
grid on

subplot(2,2,2)
plot(t,x2,'ro-',t,abs(Xdmd_q2(2,:)),'b*--')
legend('Lynx','DMD Lynx');
title('Q2 Lynx Comparison')
grid on

subplot(2,2,3);
semilogy(abs(diag(S_q2)),'ko');
title('Sigma')
grid on

subplot(2,2,4)
plot(omega_q2,'ko')
title('Omega')
xlabel('Real')
ylabel('Imagine')
grid on