% This is the code file for the Project
% Your submission file MUST run without any errors/bugs and should display
% the results in the command window.

%% For the Part II Project


% Implement your technique here
% Denoise the signal
% You can try several methods here and compare them with each other
% Also determine the best method to denoise the signal without any loss of
% information
sim('sensor_model')

alpha = 2;
K_l = 1;
xd = 0;
syms xs ys;

t = 0:0.005:15;
w_1 = 2*pi;
source = 10*sin(w_1*t);
ps = sumsqr(source)/3000;

start_length = 4000;
start_height = 2;
end_height = 10;
m = [];
for yd = start_height:1:end_height
    a = simout(start_length : start_length+3000);
    b = medfilt1(a, 10);
    pd = sumsqr(b)/3000;
    l = [yd pd];
    m = vertcat(m,l);
    start_length = start_length+4000;
end

yd = m(:, 1);
pd = m(:, 2);

d_l = (K_l*ps./pd).^(1/alpha);

sol = [];
for a = 1:1:size(yd)-1
    d1 = (xs-xd)^2+(ys-yd(a))^2 == (d_l(a))^2;
    d2 = (xs-xd)^2+(ys-yd(a+1))^2 == (d_l(a+1))^2;
    S = solve(d1, d2, xs>0, ys>0, 'ReturnConditions', true);
    sa = [vpa(S.xs) vpa(S.ys)];
    sol = vertcat(sol, sa);
end

x_s = round(mean(sol(:, 1)));
y_s = round(mean(sol(:, 2)));
fprintf('The estimated x coordinate of the source is %d.\n', x_s);
fprintf('The estimated y coordinate of the source is %d.\n', y_s);

