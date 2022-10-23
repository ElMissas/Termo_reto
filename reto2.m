clear, clc, close all

Mtotal = 1e5;  % Cantidad total de dinero en el sistema (debe ser múltiplo de N)
N = 1000;        % Número de agentes
yf = 20;    % Número de años
wa = 10;    wb = 90;
K = 50;         % Número de clases

% M(i): dinero del agente i
% e(i): empleador del agente i
M = Mtotal/N .* ones(1,N);   % Todos comienzan con la misma cantidad de dinero
e = zeros(1,N);         % Todos comienzan desempleados
V = 0;      % No hay valor en el mercado

cmax = 10*Mtotal/N;
C = linspace(0,cmax,K+1);
dC = C(2) - C(1);
alpha = 5;

ns = zeros(yf*12,K);
S = zeros(1,yf*12);
O = zeros(1,yf*12);

%%% -- Inicio de una iteración -- %%%

income = zeros(yf,N);
for year = 1:yf
    for month = 1:12
        i = (year-1)*12+month;
        for k = 1:K
            ind = (C(k) <= M) & (M < C(k+1));
            ns(i,k) = sum(ind);
            oMk(k) = 1 - exp(-alpha*C(k+1));
            %             oMk = alpha.*C(k+1);
        end
        S(i) = entropia(ns(i,:));
        O(i) = sum(ns(i,:) .* oMk);
        
        for i = 1:N
%             ii = (year-1)*12+(month-1)*N+i;
%             for k = 1:K
%                 ind = (C(k) <= M) & (M < C(k+1));
%                 ns(ii,k) = sum(ind);
%                 oMk(k) = 1 - exp(-alpha*C(k+1));
%                 %             oMk = alpha.*C(k+1);
%             end
%             S(i) = entropia(ns(ii,:));
%             O(i) = sum(ns(ii,:) .* oMk);
            
            a = S1(N);
            e = H1(a,M,e,wa,wb);
            [M,V] = E1(a,M,V);
            
            m = M;
            [M,V] = M1(a,M,e,V);
            e = F1(a,M,e,wa,wb);
            M = W1(a,M,e,wa,wb);
            income(year,:) = income(year,:) + M-m;
        end
        
        fprintf("Año: %d\tMes: %d\n", year, month)
    end
end

in = income(1,:);
m = 0:10:max(M);
for i = 1:length(m)
    Mw = M(e~=0);
    Mc = [];
    for n = 1:N
        if e(n) == 0 && sum(e==n) ~= 0
            Mc = [Mc M(n)];
        end
    end
    P(i) = sum(M >= m(i))./N;
    Pw(i) = sum(Mw >= m(i))./N;
    Pc(i) = sum(Mc >= m(i))./N;
end

Nworkers = sum(e~=0);
Ncapitalists = 0;
for n = 1:N
    if sum(e==n) ~= 0
        Ncapitalists = Ncapitalists + 1;
    end
end

%% Figuras
close all

figure
tiledlayout(1,2)
nexttile
loglog(m,P,'.b','LineWidth',1)
set(gca,'FontSize',14)
title("Distribuci\'on de ingreso total",'Interpreter','latex',...
    'FontSize',16)
ylabel("$P(M\geq m)$",'Interpreter','latex')
xlabel("$m$",'Interpreter','latex')

nexttile
loglog(m,Pw,'.b','LineWidth',1)
hold on
loglog(m,Pc,'.r','LineWidth',1)
set(gca,'FontSize',14)
title("Distribuci\'on de ingreso desagregado",'Interpreter','latex',...
    'FontSize',16)
ylabel("$P(M\geq m)$",'Interpreter','latex')
xlabel("$m$",'Interpreter','latex')
legend({'Trabajadores','Capitalistas'},'Interpreter','latex')

figure
tiledlayout(1,2)
nexttile
plot(S,'b','LineWidth',1)
set(gca,'FontSize',14)
title("Entrop\'ia",'Interpreter','latex','FontSize',16)
ylabel("$S(t)$",'Interpreter','latex')
xlabel("$t$",'Interpreter','latex')

nexttile
plot(O,'b','LineWidth',1)
set(gca,'FontSize',14)
title("Funci\'on objetivo",'Interpreter','latex','FontSize',16)
ylabel("$O(t)$",'Interpreter','latex')
xlabel("$t$",'Interpreter','latex')
ylim([980 inf])

function S = entropia(n)
N = sum(n);
p = n.*log(n);
p(isnan(p)) = 0;
S = N*log(N) - sum(p);
end