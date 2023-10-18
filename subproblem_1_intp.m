clear;

mat_input = readmatrix("data_B.xlsx");

v_alpha = mat_input(:, 2);
n = length(v_alpha);
k = n / 3;

v_alpha_m = v_alpha((k + 1):n);
v_alpha_l = v_alpha(1:k);

n_prm = (n - k);
n_vars = n_prm * k + 1;

A_eq = zeros(n_prm + k, n_vars);
for i = 1:n_prm
    A_eq(i, ((k * (i - 1)) + 1):(k * i)) = 1;
end
for i = 1:k
    A_eq(n_prm + i, i:k:(n_vars - 1)) = 1;
end

b_eq = zeros(n_prm + k, 1);
b_eq(1:n_prm) = 1;
b_eq((n_prm + 1):(n_prm + k)) = 2;

A_ineq = zeros(k, n_vars);
for i = 1:k
    for j = 1:n_prm
        A_ineq(i, k * (j - 1) + i) = -v_alpha_m(j);
    end
end
for i = 1:k
    A_ineq(i, n_vars) = -1;
end

b_ineq = v_alpha_l;

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
sol_norm = reshape(round(sol(1:(n_vars - 1))), [k, n_prm]).';

result = zeros(k, 3);
result(:, 1) = 1:k;
for g = 1:k
    p = 2;
    for i = 1:n_prm
        if sol_norm(i, g) == 1
            result(g, p) = i + k;
            p = p + 1;
        end
    end
end

disp(result);
disp(min(sum(v_alpha_m .* sol_norm, 1) + v_alpha_l.'));