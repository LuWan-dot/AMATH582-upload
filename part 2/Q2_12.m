%Q1: Train a NN for KS equation
% a NN can advance from t to t+dt
clear all, close all
input=[];
output=[];
N = 4;
for j=1:100
    u0 = randn(N,1);
    [t,x,u] = KSequation(u0,N);
     input = [input; u(1:end-1,:)];
    output = [output; u(2:end,:)];
    
end
%%
net = feedforwardnet([10 10 10]);
net.layers{1}.transferFcn = 'logsig';
net.layers{2}.transferFcn = 'radbas';
net.layers{3}.transferFcn = 'purelin';

net = train(net,input.',output.');
%%
%Q2: Compare with different initial conditions
u_kk = randn(N,1);
[t_real,x_real,u_real] = KSequation(u_kk,N);
u_test1 = u_real(1,:).';
unn(1,:)=u_test1;
for jj=2:length(t_real)
    unext = net(u_test1);
    unn(jj,:)=unext.';
    u_test1=unext;
end
 %%   
figure(1)
subplot(2,1,1)
pcolor(x_real,t_real,u_real),shading interp, colormap(hot)
title('Real data')
subplot(2,1,2)
pcolor(x_real,t_real,unn),shading interp, colormap(hot)
title('NN data')
figure(2)
surf(u_real-unn)
title('error')
colormap hsv
colorbar