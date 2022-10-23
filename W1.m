function [M,e] = W1(a,M,e,wa,wb)
%W1
% - Regla del salario W₁(a) - %
% Por cada empleado c de a,
% Transferir w dinero a c, donde w se elige al azar entre [w_min, w_max]
% Pero si M(a) < w, entonces darle a c w entre [0, M(a)] (el capitalista no
%   tiene suficiente dinero para pagar los salarios) XD

N = length(M);

% Hallar empleados de a
A = 1:N;
Wa = A(e==a);

% Pagar
for c = Wa
    % Seleccionar dw entre [wa wb]. Si a no tiene dinero para pagar,
    % entonces elegir dw entre [0 M(a)]
    dw = randi([wa wb]);
    if M(a) < dw
        dw = randi([0 M(a)]);
    end
    
    % Darle dw al empleado y restar dw al capitalista
    M(c) = M(c) + dw;
    M(a) = M(a) - dw;
end

end

