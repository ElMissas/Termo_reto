function [M,V] = E1(a,M,V)
%E1 Regla de gasto
% - Regla de gasto E₁(a) - %
% Seleccionar otro agente al azar b (que no sea a)
% Generar cantidad de gasto dm al azar entre [0, M(b)], M(b)*rand
% Añadir dm al valor del mercado V, V += dm; M(b) -= dm
N = length(M);

% Seleccionar b ~= a
while true
    b = randi([1 N]);
    if b ~= a
        break
    end
end

% Generar gasto al azar dm
dm = randi([0 M(b)]);

% Realizar el gasto
V = V + dm;
M(b) = M(b) - dm;

end

