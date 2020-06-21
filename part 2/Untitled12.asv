%%%%Q3 Reaction-diffusion system SVD
clear all, close all
%%% load data from original provided code
load('reaction_diffusion_big.mat')
%%
%%% apply SVD on u, for every snapshot
dt = t(2) - t(1);
numt = length(t);
U = zeros(length(x),length(y),length(t));
V = zeros(length(x),length(y),length(t));
S = zeros(length(x),length(y),length(t));
for j=1:numt
    [U(:,:,j),S(:,:,j),V(:,:,j)] = svd(u(:,:,j),'econ');
end
%%% plot sigma of SVD for each snapshot
%%% It could be found that the previous 10 space could be a good approx.
for jj=1:numt
   semilogx(abs(diag(S(:,:,jj))),'ko-'), hold on
   title('Sigma of every snapshot')
end

%%% truncate to rank-r, in order to represent the orginal model in low rank
%%% space
r = 10;
U_r = U(:,1:r,:);
S_r = S(1:r,1:r,:);
V_r = V(:,1:r,:);

%%% Convert approximated u with low rank space
u_approx = zeros(length(x),length(y),numt);
for jj=1:numt
    u_approx(:,:,jj) = U_r(:,:,jj)*S_r(:,:,jj)*V_r(:,:,jj)';
end

%%% compare the orginal u and the approximated u
figure;
subplot(2,1,1)
pcolor(x,y,u_approx(:,:,end)); shading interp; colormap(hot)
title('approximated u')

subplot(2,1,2)
pcolor(x,y,u(:,:,end)); shading interp; colormap(hot)
title('orginal u')
%%
%%% apply NN on u low rank
dt = t(2) - t(1);
numt = length(t);
numOne = length(u(:,1,1))*length(u(1,:,1));
num1 = length(u(:,1,1));
uu = reshape(u,numOne,numt);
%%
for jj=1:numt
SS_r(:,jj) = reshape(S_r(:,:,jj),r*r,1);
UU_r(:,jj) = reshape(U_r(:,:,jj),num1*r,1);
VV_r(:,jj) = reshape(V_r(:,:,jj),num1*r,1);
end
input = [];
output = [];
for jj=1:1
     input = [input; SS_r(:,1:end-1); UU_r(:,1:end-1);VV_r(:,1:end-1)];
    output = [output; SS_r(:,2:end); UU_r(:,2:end);VV_r(:,2:end)];
end
%%
net = feedforwardnet([10 10 10]);
net.layers{1}.transferFcn = 'logsig';
net.layers{2}.transferFcn = 'radbas';
net.layers{3}.transferFcn = 'purelin';

net = train(net,input.',output.');

% for j=1:100
%     u0 = randn(N,1);
%     [t,x,u] = KSequation(u0,N);
%      input = [input; u(1:end-1,:)];
%     output = [output; u(2:end,:)];
%     
% end
