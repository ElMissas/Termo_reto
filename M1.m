function [M,V] = M1(a,M,e,V)
%M1
% - Regla de venta (market sample) M₁(a) - %
% Si a no es desempleado (e(a) ~= 0 || sum(e==a) ~= 0)
    % Generar al azar dm entre [0, V], V*rand
    % Restar dm de V: V -= dm
    % Si a es un empleado, darle dm a su empleador: M(e(a)) += dm
    % Si a es un capitalista, darle dm: M(a) += dm
    
% Checar que a no sea desempleado
if e(a) ~= 0 || sum(e==a) ~= 0
    % Generar dm al azar
    dm = randi([0 V]);
    V = V - dm;
    % Checar si a es trabajador o capitalista
    if sum(e==a) == 0               % Si a es trabajador...
        M(e(a)) = M(e(a)) + dm;     % Darle dm a su empleador
    else                            % Si a es capitalista...
        M(a) = M(a) + dm;           % Darle dm a a
    end
end
end

