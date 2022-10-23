clear, clc, close all

Nl = 21;

lambdas = linspace(0,1,Nl);
taus = 10:20:500;
N = 25;

Nt = length(taus);

S = zeros(Nl,Nt);
O = zeros(Nl,Nt);

% tic
% for i = 1:Nl
%     for j = 1:Nt
%         Sn = zeros(1,N);
%         for k = 1:N
%             Sn(k) = S_inf(lambdas(i),taus(j));
%             fprintf("i = %d\tj = %d\tk = %d\n", i, j, k)
%         end
%         S(i,j) = mean(Sn);
%     end
% end
% toc

tic
for i = 1:Nl
    for j = 1:Nt
        On = zeros(1,N);
        for k = 1:N
            [~,~,~,OO] = sim1("delta",lambdas(i),taus(j));
            fprintf("i = %d\tj = %d\tk = %d\n", i, j, k)
            On(k) = OO(end);
        end
        O(i,j) = mean(On);
    end
end
toc

[L,T] = meshgrid(lambdas,taus);
%% Gráfica
% surf(L,T,S.')
% xlabel("$\lambda$",'Interpreter','latex')
% ylabel("$\tau$",'Interpreter','latex')
% zlabel("$S_\infty$",'Interpreter','latex')
% title("Entrop\'ia final $S_\infty$",'interpreter','latex')
% axis square

surf(L,T,O')
xlabel("$\lambda$",'Interpreter','latex')
ylabel("$\tau$",'Interpreter','latex')
zlabel("$O_\infty$",'Interpreter','latex')
title("Funci\'on objetivo final $O_\infty$",'interpreter','latex')
axis square


function S = S_inf(lambda,tau)
% Definir parámetros del problema
N = 1000;       % Agentes
M = 100;        % Dinero total
K = 30;         % Número de clases
t = 1e5;        % Tiempo

cmax = 8*M/N;
C = linspace(0,cmax,K+1);

% Todos comienzan con la misma cantidad de dinero
% X = M/N .* ones(1,N);

% Distribución inicial uniforme
X = rand(1,N);
X = X./sum(X) .* M;

% Agente especial
A = 0;

% Variables
n = zeros(1,K);

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
    if mod(i,tau) == 0 || i == t
        X = X + A/N;
        A = 0;
    end
end

for k = 1:K
    ind = (C(k) <= X) & (X < C(k+1));
    n(k) = sum(ind);
end

p = n.*log(n);
p(isnan(p)) = 0;
S = N*log(N) - sum(p);
end