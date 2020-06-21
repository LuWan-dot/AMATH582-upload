%%%% Q3.1 Train a NN to advance the solution from t to t + t for  = 10; 
%%28 and 40. Now see how well your NN works for future state prediction for
%% = 17 and  = 35.
% Simulate Lorenz system
dt=0.01; T=8; t=0:dt:T;
b=8/3; sig=10;
%r_rain=[10, 28, 40];
r1 = 10;
r2 = 28;
r3 = 40;
Lorenz1 = @(t,x)([ sig * (x(2) - x(1))       ; ...
                  r1 * x(1)-x(1) * x(3) - x(2) ; ...
                  x(1) * x(2) - b*x(3)         ]);  
              
Lorenz2 = @(t,x)([ sig * (x(2) - x(1))       ; ...
                  r2 * x(1)-x(1) * x(3) - x(2) ; ...
                  x(1) * x(2) - b*x(3)         ]);  
              
Lorenz3 = @(t,x)([ sig * (x(2) - x(1))       ; ...
                  r3 * x(1)-x(1) * x(3) - x(2) ; ...
                  x(1) * x(2) - b*x(3)         ]);  
r4 = 17;
r5 = 35;              
Lorenz4 = @(t,x)([ sig * (x(2) - x(1))       ; ...
                  r4 * x(1)-x(1) * x(3) - x(2) ; ...
                  x(1) * x(2) - b*x(3)         ]);  
              
Lorenz5 = @(t,x)([ sig * (x(2) - x(1))       ; ...
                  r5 * x(1)-x(1) * x(3) - x(2) ; ...
                  x(1) * x(2) - b*x(3)         ]);  
           
ode_options = odeset('RelTol',1e-10, 'AbsTol',1e-11);
input=[]; output=[];
for j=1:100  % training trajectories
 
    x0=30*(rand(3,1)-0.5);
    [t,y] = ode45(Lorenz1,t,x0);
    input=[input; y(1:end-1,:)];
    output=[output; y(2:end,:)];
    plot3(y(:,1),y(:,2),y(:,3)), hold on
    plot3(x0(1),x0(2),x0(3),'ro')
    
    [t,y] = ode45(Lorenz2,t,x0);
    input=[input; y(1:end-1,:)];
    output=[output; y(2:end,:)];
    plot3(y(:,1),y(:,2),y(:,3)), hold on
    plot3(x0(1),x0(2),x0(3),'ro')
    
    [t,y] = ode45(Lorenz3,t,x0);
    input=[input; y(1:end-1,:)];
    output=[output; y(2:end,:)];
    plot3(y(:,1),y(:,2),y(:,3)), hold on
    plot3(x0(1),x0(2),x0(3),'ro')
    
end
grid on, view(-23,18)
%%
net = feedforwardnet([10 10 10]);
net.layers{1}.transferFcn = 'logsig';
net.layers{2}.transferFcn = 'radbas';
net.layers{3}.transferFcn = 'purelin';
net = train(net,input.',output.');
%%
figure(2)
x0=30*(rand(3,1)-0.5);
[t,y] = ode45(Lorenz4,t,x0);
plot3(y(:,1),y(:,2),y(:,3)), hold on
plot3(x0(1),x0(2),x0(3),'ro','Linewidth',[2])
grid on

ynn(1,:)=x0;
for jj=2:length(t)
    y0=net(x0);
    ynn(jj,:)=y0.'; x0=y0;
end
plot3(ynn(:,1),ynn(:,2),ynn(:,3),':','Linewidth',[2])
figure(3)
subplot(3,2,1), plot(t,y(:,1),t,ynn(:,1),'Linewidth',[2])
subplot(3,2,3), plot(t,y(:,2),t,ynn(:,2),'Linewidth',[2])
subplot(3,2,5), plot(t,y(:,3),t,ynn(:,3),'Linewidth',[2])
figure(2)
x0=20*(rand(3,1)-0.5);
[t,y] = ode45(Lorenz5,t,x0);
plot3(y(:,1),y(:,2),y(:,3)), hold on
plot3(x0(1),x0(2),x0(3),'ro','Linewidth',[2])
grid on

ynn(1,:)=x0;
for jj=2:length(t)
    y0=net(x0);
    ynn(jj,:)=y0.'; x0=y0;
end
plot3(ynn(:,1),ynn(:,2),ynn(:,3),':','Linewidth',[2])

figure(3)
subplot(3,2,2), plot(t,y(:,1),t,ynn(:,1),'Linewidth',[2])
subplot(3,2,4), plot(t,y(:,2),t,ynn(:,2),'Linewidth',[2])
subplot(3,2,6), plot(t,y(:,3),t,ynn(:,3),'Linewidth',[2])

%%
figure(2), view(-75,15)
figure(3)
subplot(3,2,1), set(gca,'Fontsize',[15],'Xlim',[0 8])
subplot(3,2,2), set(gca,'Fontsize',[15],'Xlim',[0 8])
subplot(3,2,3), set(gca,'Fontsize',[15],'Xlim',[0 8])
subplot(3,2,4), set(gca,'Fontsize',[15],'Xlim',[0 8])
subplot(3,2,5), set(gca,'Fontsize',[15],'Xlim',[0 8])
subplot(3,2,6), set(gca,'Fontsize',[15],'Xlim',[0 8])
legend('Lorenz','NN')