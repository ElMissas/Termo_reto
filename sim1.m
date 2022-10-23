function [XT,n,S,O] = sim1(dist_ini,lambda,tau)
M = 100;
N = 1000;
K = 30;
t = 2e4;
a = 2;

tt = 100;

cmax = 8*M/N;
C = linspace(0,cmax,K+1);

switch dist_ini
    case "delta"
        % Todos comienzan con la misma cantidad de dinero
        X = M/N .* ones(1,N);
    case "const"
        % Distribución inicial uniforme
        X = rand(1,N);
        X = X./sum(X) .* M;
end

XT = zeros(t/tt+1,N);
XT(1,:) = X;
% Agente especial
A = 0;

% Variables
n = zeros(t/tt+1,K);
S = zeros(1,t/tt+1);
O = zeros(1,t/tt+1);

for k = 1:K
    ind = (C(k) <= X) & (X < C(k+1));
    n(1,k) = sum(ind);
    oMk1(k) = 1 - exp(-a*C(k+1));
    oMk2(k) = a*C(k+1);
    %             oMk = a.*C(k+1);
end
% Calcular S
S(1) = entropia(n(1,:));
O(1,1) = sum(n(1,:) .* oMk1);
O(2,1) = sum(n(1,:) .* oMk2);

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
    
    % Contar los miembros de cada clase
    if mod(i,tt) == 0 || i == t
        XT(i/tt+1,:) = X;
        for k = 1:K
            ind = (C(k) <= X) & (X < C(k+1));
            n(i/tt+1,k) = sum(ind);
            oMk1(k) = 1 - exp(-a*C(k+1));
            oMk2(k) = a*C(k+1);
%             oMk = a.*C(k+1);
        end
        % Calcular S
        S(i/tt+1) = entropia(n(i/tt+1,:));
        O(1,i/tt+1) = sum(n(i/tt+1,:) .* oMk1);
        O(2,i/tt+1) = sum(n(i/tt+1,:) .* oMk2);
    end
end

function S = entropia(n)
N = sum(n);
p = n.*log(n);
p(isnan(p)) = 0;
S = N*log(N) - sum(p);
end
end

