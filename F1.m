function e = F1(a,M,e,wa,wb)
%F1
% - Regla de despido F₁(a) - %
% Si a es empleador, determinar el número de empelados a despedir u
    % u = max(número de empleados de a - round(M(a)/w_p),0)
    % Despedir u empleados al azar: hacer e = 0 para cada uno

N = length(M);
% Checar si a es capitalista
if sum(e==a) ~= 0
    % Hallar el número de empleados de a
    A = 1:N;
    Wa = A(e==a);
    w_p = (wa + wb) / 2;    % Salario promedio
    
    % Determinar el número de despidos u
    u = max(length(Wa) - round(M(a)/w_p),0);
    
    % Despedir u empleados
    des = randsample(Wa,u);
    e(des) = 0;
end

