clear;

mat_input = readmatrix("data_A.xlsx");

v_alpha = mat_input(:, 2);
n = length(v_alpha);
k = n / 3;
n_vars = n * k + 1;

A_eq = zeros(n + k, n_vars);
for i = 1:n
    A_eq(i, ((k * (i - 1)) + 1):(k * i)) = 1;
end
for i = 1:k
    A_eq(n + i, i:k:(n_vars - 1)) = 1;
end

b_eq = zeros(n + k, 1);
b_eq(1:n) = 1;
b_eq((n + 1):(n + k)) = 3;

A_ineq = zeros(k, n_vars);
for i = 1:k
    for j = 1:n
        A_ineq(i, k * (j - 1) + i) = -v_alpha(j);
    end
end
for i = 1:k
    A_ineq(i, n_vars) = -1;
end

b_ineq = zeros(k, 1);

f = zeros(n_vars, 1);
f(n_vars) = 1;

lb = zeros(n_vars, 1);
lb(n_vars) = -Inf;
ub = ones(n_vars, 1);
ub(n_vars) = Inf;

opts = optimoptions(@intlinprog, ...
    "CutGeneration", "advanced", ...
    "Heuristics", "advanced", ...
    "IntegerPreprocess", "advanced", ...
    "MaxNodes", 1e6);

[sol, obj_val] = intlinprog(f, ...
    1:(n_vars - 1), ...
    A_ineq, b_ineq, A_eq ,b_eq, ...
    lb, ub, ...
    [], opts);

obj_val_norm = -obj_val;
sol_norm = reshape(round(sol(1:(n_vars - 1))), [k, n]).';

result = zeros(k, 3);
for g = 1:k
    p = 1;
    for i = 1:n
        if sol_norm(i, g) == 1
            result(g, p) = i;
            p = p + 1;
        end
    end
end

disp(result);
disp(min(sum(v_alpha .* sol_norm, 1)));