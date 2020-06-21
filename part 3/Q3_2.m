%%%% Q3.2 predict the transition
clear all; close all
dt=0.01; T=8; t=0:dt:T;
b=8/3; sig=10;
r = 28;
Lorenz = @(t,x)([ sig * (x(2) - x(1))       ; ...
                  r * x(1)-x(1) * x(3) - x(2) ; ...
                  x(1) * x(2) - b*x(3)         ]);  
input=[];
output=[];
k = 1;
kk = 20;
t_window = dt*kk;
t_pre = dt*k;
lent = length(t);
for j=1:100  % training trajectories
    x0=30*(rand(3,1)-0.5);
    [t,y] = ode45(Lorenz,t,x0);
    signout = 1;
    signsum = 1;
    for n=1:lent-1
        signout = sign(y(n,1)*y(n+1,1));
        if signout >0
            signout2 = 0;
        else 
            signout2 = 1;
        end
        signsum(n) = signout2;  
    end
  
    lent2 = lent-kk-k-1;
    for i=1:lent-kk-k-1
        input(:,i+(j-1)*(lent2))=[y(i:i+kk,1);y(i:i+kk,2);y(i:i+kk,3)];
        output(1,i+(j-1)*(lent2))=signsum(i+kk+k);
    
    end
end
   
net = feedforwardnet([10 10 10]);
net.layers{1}.transferFcn = 'logsig';
net.layers{2}.transferFcn = 'radbas';
net.layers{3}.transferFcn = 'purelin';
net = train(net,input,output);

%%
x0=30*(rand(3,1)-0.5);
[t,y] = ode45(Lorenz,t,x0);
signout = 1;
signsum = 1;
for j=1:length(t)-1
    signout = sign(y(j,1)*y(j+1,1));
    if signout >0
        signout2 = 0;
    else 
        signout2 = 1;
    end
   signsum(j) = signout2;  
end

figure;
subplot(3,1,1)
plot(t,y(:,1),'Linewidth',[2])
title('x state')
subplot(3,1,2)
plot(t(1:end-1),signsum)
title('real trasition')

for i=1:lent-kk-k-1
    x0 = [y(i:i+kk,1);y(i:i+kk,2);y(i:i+kk,3)];
    label(i) = net(x0);
end

subplot(3,1,3)
plot(t(1:i),label)
title('NN prediction of transition')

