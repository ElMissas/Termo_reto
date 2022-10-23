function e = H1(a,M,e,wa,wb)
%H1
% - Regla de contratación H₁ - %
% Si a está desempleado y no tiene empleados...
    % Hallar los posibles empleadores H = [e == 0]
    % Elegir empleador con probabilidad P(c) = M(c)/sum(M de los H)
    % Si M(c) > w_p (salario promedio), entonces c contrata a a
    
N = length(M);
w_p = (wa + wb) / 2;

% Checar si a está desempleado
if e(a) == 0 && sum(e==a) == 0
    % Hallar posibles empleadores
    A = 1:N;
    H = A(e==0);
    
    % Escoger uno al azar
    p = M(H) ./ sum(M(H));  % pesos
    c = randsample(H,1,true,p);
    
    % Contratar (o no)
    if M(c) >= w_p
        e(a) = c;
    end
end
end

