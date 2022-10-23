clear, clc, close all

t = 2e4;
tt = 100;
T = t/tt;
lambda = [0 0.5 1];
tau = 100;

S = zeros(6,T+1);
O = zeros(4,T+1);

for i = 1:3
    [~,~,S(i,:),~] = sim1("delta",lambda(i),tau);
    [~,~,S(i+3,:),~] = sim1("const",lambda(i),tau);
end

[~,~,~,O] = sim1("delta",0.5,100);

time = linspace(0,t,T+1);

%%
figure, hold on
plot(time,O(1,:),'b','LineWidth',2)
plot(time,O(2,:),'r','LineWidth',2)
set(gca,'FontSize',14)
title("Funci\'on objetivo",'Interpreter','latex','FontSize',18)
xlabel("$t$",'Interpreter','latex')
ylabel("$O(t)$",'Interpreter','latex')
legend({'$o(M) = 1 - \exp(-aM)$','$o(M) = aM$'},'Interpreter','latex')
grid on

%%
figure
tl = tiledlayout(3,3);
nexttile(1,[3,3])
hold on
plot(time,S(1,:),'b','LineWidth',2)
plot(time,S(2,:),'--b','LineWidth',2)
plot(time,S(3,:),':b','LineWidth',2)

plot(time,S(4,:),'r','LineWidth',2)
plot(time,S(5,:),'--r','LineWidth',2)
plot(time,S(6,:),':r','LineWidth',2)

rectangle('Position',[18000 2150 2000 200],...
    'EdgeColor','k','LineWidth',1)

set(gca,'FontSize',14)

legend({'$\delta(m-M/N)$, $\lambda=0$','$\delta(m-M/N)$, $\lambda=0.5$',...
    '$\delta(m-M/N)$, $\lambda=1$','Const., $\lambda=0$',...
    'Const., $\lambda=0.5$','Const., $\lambda=1$'},'Interpreter','latex',...
    'Location','southwest','FontSize',12)

xlabel("$t$",'Interpreter','latex')
ylabel("$S(t)$",'Interpreter','latex')
title("Entrop\'ia de varios casos, $\tau=100$",'Interpreter','latex','FontSize',16)

ax2 = axes(tl);
ax2.Layout.Tile = 9;
hold on
plot(time,S(1,:),'b','LineWidth',2)
plot(time,S(2,:),'--b','LineWidth',2)
plot(time,S(3,:),':b','LineWidth',2)

plot(time,S(4,:),'r','LineWidth',2)
plot(time,S(5,:),'--r','LineWidth',2)
plot(time,S(6,:),':r','LineWidth',2)
xticks([])
ax2.Box = 'on';
ax2.XAxis.Color = 'k';
ax2.YAxis.Color = 'k';
ax2.YAxisLocation = 'right';
axis([1.8e4 2e4 2150 2350])

%% O
for i = 1:2
    [~,~,~,O(i,:)] = sim1("delta",lambda(i+1),100);
    [~,~,~,O(i+2,:)] = sim1("delta",lambda(i+1),1000);
end

figure, hold on
lspec = ["--b","--r","b","r"];
for i = 1:4
    plot(time,O(i,:),lspec(i),'LineWidth',1)
end
legend({'$\lambda=0.5$, $\tau=100$','$\lambda=1$, $\tau=100$',...
    '$\lambda=0.5$, $\tau=1000$',...
    '$\lambda=1$, $\tau=1000$'},'Interpreter','latex')
set(gca,'FontSize',14)
xlabel("$t$",'Interpreter','latex')
ylabel("$O(t)$",'Interpreter','latex')
title("Funci\'on objetivo de varios casos",'Interpreter','latex','FontSize',16)