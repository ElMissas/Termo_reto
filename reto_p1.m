clear, clc, close all

% Definir parámetros del problema
N = 1000;       % Agentes
M = 100;        % Dinero total
K = 30;         % Número de clases
t = 3e4;        % Tiempo
lambda = 0.95;  % IVA
tau = 450;      % Tiempo de repartición del IVA

a = linspace(0,30,240);

tt = 100;
time = linspace(0,t,t/tt+1);

cmax = 8*M/N;
C = linspace(0,cmax,K+1);
dC = C(2) - C(1);


% Todos comienzan con la misma cantidad de dinero
X = M/N .* ones(1,N);

% Distribución inicial uniforme
% X = rand(1,N);
% X = X./sum(X) .* M;

XT = zeros(t/tt+1,N);
XT(1,:) = X;
% Agente especial
A = 0;

% Variables
n = zeros(t/tt+1,K);
S = zeros(1,t/tt+1);
O = zeros(length(a),t/tt+1);

for J = 1:length(a)
    for k = 1:K
        ind = (C(k) <= X) & (X < C(k+1));
        n(1,k) = sum(ind);
        
        oMk(k) = 1 - exp(-a(J)*C(k+1));
        
        %             oMk = a.*C(k+1);
    end
    O(J,1) = sum(n(1,:) .* oMk);
end
% Calcular S
S(1) = entropia(n(1,:));

% Ciclo
for i = 1:t 
    % Elegir dos agentes al azar
    j = randi([1 N],1,2);
    j1 = j(1);  j2 = j(2);
    
    % Definir cantidad a intercambiar
    delta = 0.05*rand;
    
    % Realizar intercambio
    if X(j1)-delta >= 0
        X(j1) = X(j1) - delta;
        X(j2) = X(j2) + (1-lambda)*delta;
        
        A = A + lambda*delta;
    end
    
    % Agente especial
    if mod(i,tau) == 0
        X = X + A/N;
        A = 0;
    end
    
    % Contar los miembros de cada clase
    if mod(i,tt) == 0 || i == t
        XT(i/tt+1,:) = X;
        for J = 1:length(a)
            for k = 1:K
                ind = (C(k) <= X) & (X < C(k+1));
                n(i/tt+1,k) = sum(ind);
                
                
                oMk(k) = 1 - exp(-a(J)*C(k+1));
                
                %             oMk = a.*C(k+1);
                
            end
            O(J,i/tt+1) = sum(n(i/tt+1,:) .* oMk);
        end
        % Calcular S
        S(i/tt+1) = entropia(n(i/tt+1,:));
    end
end

%% GIF O(t)
fig0 = figure;  fig0.Position = [24 280 718 518];

for idx = 1:length(a)
%     nexttile(1)
%     cla
%     plot(time,O(idx,:),'b','LineWidth',1)
%     xlabel("$t$",'Interpreter','latex')
%     ylabel("$O(t)$",'Interpreter','latex')
%     rectangle('Position',...
%         [0 min(O(idx,:))-2 t max(O(idx,:))-min(O(idx,:))+4],...
%         'EdgeColor','k','LineWidth',1)
%     axis([0 t 0.85*min(min(O)) 1.15*max(max(O))])
%     title("Funci\'on objetivo",'Interpreter','latex','FontSize',16)
%     
%     nexttile(2)
    cla
    plot(time,O(idx,:),'b','LineWidth',1)
    set(gca,'FontSize',14)
    xlabel("$t$",'Interpreter','latex')
    ylabel("$O(t)$",'Interpreter','latex')
    axis([0 t min(O(idx,:))-2 max(O(idx,:))+2])
    title("Funci\'on objetivo, con $o_1(M) = 1 - \exp(-aM)$",...
        'Interpreter','latex','FontSize',18)
    text(6000,O(idx,15),"$a = "+string(a(idx))+"$",'Interpreter','latex',...
        'FontSize',18)
    drawnow
    
    frame = getframe(fig0);
    im{idx} = frame2im(frame);
end
nImages = length(a);
filename = 'objetivoGIF.gif';
duracion = 7;   % Segundos
delay = duracion/nImages;
for idx = 1:nImages
    [A,map] = rgb2ind(im{idx},256);
    if idx == 1
        imwrite(A,map,filename,'gif','LoopCount',Inf,'DelayTime',delay)
    else
        imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',delay)
    end
end
fprintf("GIF guardado como: "+filename+"\n")
%% Histogramas y plots
close all
% Histograma normal
figure, hold on
b1 = bar(C(1:end-1),n(end,:),'histc');
b1.FaceColor = 'c';
set(gca,'FontSize',14)
xlabel("$m$",'Interpreter','latex')
ylabel("$P(M=m)$",'Interpreter','latex')
title("Histograma",'Interpreter','latex','FontSize',18)

% Histograma semilogarítmico
figure, hold on
b2 = bar(C(1:end-1),log(n(end,:)),'histc');
b2.FaceColor = 'c';
set(gca,'FontSize',14)
title("Histograma semilogar\'itmico",'Interpreter','latex','FontSize',18)
xlabel("$m$",'Interpreter','latex')
ylabel("$\ln(P(M=m))$",'Interpreter','latex')

% Gráfica de S
figure
plot(time,S,'b','LineWidth',2)
set(gca,'FontSize',14)
TT = "Entrop\'ia, $\tau = "+string(tau)+"$, $\lambda = "...
    +string(lambda)+"$";
title(TT,'Interpreter','latex','FontSize',18)
xlabel("$t$",'Interpreter','latex')
ylabel("$S(t)$",'Interpreter','latex')

% Gráfica de O
figure
plot(time,O,'b','LineWidth',2)
set(gca,'FontSize',14)
TT = "Funci\'on objetivo, $\tau = "+string(tau)+"$, $\lambda = "...
    +string(lambda)+"$";
title(TT,'Interpreter','latex','FontSize',18)
xlabel("$t$",'Interpreter','latex')
ylabel("$O(t)$",'Interpreter','latex')

% FIGURA HISTOGRAMAS
figH = figure;
tiledlayout(1,2)
nexttile
hold on
set(gca,'FontSize',14)
histogram(XT(end,:),C,'FaceColor','none','EdgeColor','g','LineWidth',2)
histogram(XT(50,:),C,'FaceColor','none','EdgeColor','r','LineWidth',2)
histogram(XT(1,:),C,'FaceColor','none','EdgeColor','b','LineWidth',2)
axis([0 0.5 0 300])
legend({'$t_3=2\times10^4$','$t_2=5000$','$t_1=0$'},'interpreter','latex')
title("Histograma. $\lambda=0$",'Interpreter','latex','FontSize',16)
xlabel("$m$",'Interpreter','latex')
ylabel("$P(M=m)$",'Interpreter','latex')

nexttile
hold on
histogram(XT(end,:),C,'FaceColor','none','EdgeColor','g','LineWidth',2)
histogram(XT(50,:),C,'FaceColor','none','EdgeColor','r','LineWidth',2)
histogram(XT(1,:),C,'FaceColor','none','EdgeColor','b','LineWidth',2)
xlim([0 0.5])
set(gca,'yscale','log')
set(gca,'FontSize',14)
legend({'$t_3=2\times10^4$','$t_2=5000$','$t_1=0$'},'interpreter','latex')
title("Histograma semilogar\'itmico. $\lambda=0$",...
    'Interpreter','latex','FontSize',16)
xlabel("$m$",'Interpreter','latex')
ylabel("$P(M=m)$",'Interpreter','latex')

%% Animación / GIF
nImages = length(time);
im = cell(1,nImages);
fig = figure;
fig.Position = [14.6,142.6,737.6,628.8];
for i = 1:length(time)
    cla
    b5 = bar(C(1:end-1),n(i,:),'histc');
    b5.FaceColor = 'c';
    set(gca,'FontSize',16)
    xlabel("$m$",'Interpreter','latex')
    ylabel("$P(M=m)$",'Interpreter','latex')
    title("Histograma, $\lambda=0.95$, $\tau=450$",...
        'Interpreter','latex','FontSize',20)
%     title("t = "+string((i-1)*tt))
    text(0.35,140,"$t = "+string(time(i))+"$",'Interpreter','latex',...
        'FontSize',20)
    axis([0 0.6 0 300])
    drawnow
    
    frame = getframe(fig);
    im{i} = frame2im(frame);
end
close;
filename = 'simulacionOptim.gif';
duracion = 5;   % Segundos
delay = duracion/nImages;
for idx = 1:nImages
    [A,map] = rgb2ind(im{idx},256);
    if idx == 1
        imwrite(A,map,filename,'gif','LoopCount',Inf,'DelayTime',delay)
    else
        imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',delay)
    end
end
fprintf("GIF guardado como: "+filename+"\n")

function S = entropia(n)
N = sum(n);
p = n.*log(n);
p(isnan(p)) = 0;
S = N*log(N) - sum(p);
end