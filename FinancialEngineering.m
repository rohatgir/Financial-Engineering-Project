%% Part 1
% Initial Conditions
Liability = [24e6; 26e6; 28e6; 28e6; 26e6; 29e6; 32e6; 33e6; 34e6];
Price = [102.44 99.95 100.02 102.66 87.90 85.43 83.42 103.82 110.29 ...
    108.85 109.95 107.36 104.62 99.07 103.78 64.66 0 0 0 0 0 0 0 0 0]';
% Note Price includes reinvestment for later use
Coupon_payments = [5.625 4.75 4.25 5.25 0 0 0 5.75 6.875 6.5 6.625 ...
    6.125 5.265 4.75 5.5 0]';
Maturity_year = [1 2 2 3 3 4 5 5 6 6 7 7 8 8 9 9]';
reinvestment_rate = 0.02;
% Calculating Face Value
n = 0;
Face_Value = zeros(16,1);
while n < 16
    n = n + 1;
    Face_Value(n,1) = 100 + Coupon_payments(n,1);
end
% Seting up LP calculation
cp = Coupon_payments;
F = Face_Value;
% Bond Matrix
A  = zeros(9,16);
A(1,:)= [F(1,1) cp(2,1) cp(3,1) cp(4,1) cp(5,1) cp(6,1) cp(7,1) ...
    cp(8,1) cp(9,1) cp(10,1) cp(11,1) cp(12,1) cp(13,1) cp(14,1) ...
    cp(15,1) cp(16,1)];
A(2,2:16)= [F(2,1) F(3,1) cp(4,1) cp(5,1) cp(6,1) cp(7,1) cp(8,1) ...
    cp(9,1) cp(10,1) cp(11,1) cp(12,1) cp(13,1) cp(14,1) cp(15,1) ...
    cp(16,1)];
A(3,4:16)= [F(4,1) F(5,1) cp(6,1) cp(7,1) cp(8,1) cp(9,1) cp(10,1) ...
    cp(11,1) cp(12,1) cp(13,1) cp(14,1) cp(15,1) cp(16,1)];
A(4,6:16)= [F(6,1) cp(7,1) cp(8,1) cp(9,1) cp(10,1) cp(11,1) cp(12,1) ...
    cp(13,1) cp(14,1) cp(15,1) cp(16,1)];
A(5,7:16)= [F(7,1) F(8,1) cp(9,1) cp(10,1) cp(11,1) cp(12,1) cp(13,1) ... 
    cp(14,1) cp(15,1) cp(16,1)];
A(6,9:16)= [F(9,1) F(10,1) cp(11,1) cp(12,1) cp(13,1) cp(14,1) cp(15,1) ...
    cp(16,1)];
A(7,11:16)= [F(11,1) F(12,1) cp(13,1) cp(14,1) cp(15,1) cp(16,1)];
A(8,13:16)= [F(13,1) F(14,1) cp(15,1) cp(16,1)];
A(9,15:16)= [F(15,1) F(16,1)];
% Reinvestment Matrix
R = zeros(9,9);
R(1,1) = -1;
R(2,1:2) = [1.02 -1];
R(3,2:3) = [1.02 -1];
R(4,3:4) = [1.02 -1];
R(5,4:5) = [1.02 -1];
R(6,5:6) = [1.02 -1];
R(7,6:7) = [1.02 -1];
R(8,7:8) = [1.02 -1];
R(9,8:9) = [1.02 0];
B = zeros(9,25);
B(:,1:16) = A;
B(:,17:25) = R;
% LP Function
c = Price;
b = [];
A = [];
Aeq = B;
beq = Liability;
lb = zeros(25,1);
ub = (lb+1)*inf;
[x_part1,cost] = linprog(c, A, b, Aeq, beq, lb, ub)
%% Part 2A
% Import SPY, GOVT, EEMV Data into matrix
% SPY
r1 = zeros(48,1);
t = 0;
while t < 47
    t = t + 1;
    r1(t,1) = (SPY((t+1),1) - SPY(t,1))/SPY(t,1); %Calculating 
    ... return of asset
end
r1 = r1(1:2:end,:);
r1bar = mean(r1); %Average of asset
r1a = 1+r1;
mew1 = (prod(r1a))^(1/24) - 1; %Geometric expected return of asset
% GOVT
r2 = zeros(48,1);
t = 0;
while t < 47
    t = t + 1;
    r2(t,1) = (GOVT((t+1),1) - GOVT(t,1))/GOVT(t,1);
end
r2 = r2(1:2:end,:);
r2bar = mean(r2);
r2a = 1+r2;
mew2 = (prod(r2a))^(1/24) - 1;
% EEMV
r3 = zeros(48,1);
t = 0;
while t < 47
    t = t + 1;
    r3(t,1) = (EEMV((t+1),1) - EEMV(t,1))/EEMV(t,1);
end
r3 = r3(1:2:end,:);
r3bar = mean(r3);
r3a = 1+r3;
mew3 = (prod(r3a))^(1/24) - 1;

% Corivance
sig = zeros(3);
t = 0;
s11 = zeros(24,1);
while t < 24
    t = t + 1;
    s11(t,1) = (r1(t,1) - r1bar) * (r1(t,1) - r1bar);
end
sig(1,1) = (1/24)*sum(s11);
t = 0;
s22 = zeros(24,1);
while t < 24
    t = t + 1;
    s22(t,1) = (r2(t,1) - r2bar) * (r2(t,1) - r2bar);
end
sig(2,2) = (1/24)*sum(s22);
t = 0;
s33 = zeros(24,1);
while t < 24
    t = t + 1;
    s33(t,1) = (r3(t,1) - r3bar) * (r3(t,1) - r3bar);
end
sig(3,3) = (1/24)*sum(s33);
t = 0;
s12 = zeros(24,1);
while t < 24
    t = t + 1;
    s12(t,1) = (r1(t,1) - r1bar) * (r2(t,1) - r2bar);
end
sig(1,2) = (1/24)*sum(s12);
t = 0;
s13 = zeros(24,1);
while t < 24
    t = t + 1;
    s13(t,1) = (r1(t,1) - r1bar) * (r3(t,1) - r3bar);
end
sig(1,3) = (1/24)*sum(s13);
t = 0;
s23 = zeros(24,1);
while t < 24
    t = t + 1;
    s23(t,1) = (r2(t,1) - r2bar) * (r3(t,1) - r3bar);
end
sig(2,3) = (1/24)*sum(s23);
%% Part 2B
R = 0.0;
Q = [sig(1,1) sig(1,2) sig(1,3);...
    sig(1,2) sig(2,2) sig(2,3); ...
    sig(1,3) sig(2,3) sig(3,3)];
c = [0 0 0]';
A = -[mew1 mew2 mew3];
b = -R;
Aeq = [1 1 1];
beq = [1];
ub = [inf inf inf]';
lb = -ub; %Short selling
lb_without = c; %Without short selling
[x, fval] = quadprog(Q,c,A,b,Aeq,beq,lb_without,ub) %Solving MVO
var = sqrt(fval) %Getting Variance
% Constructing points for graph (R with short selling)
iterations = 20
R_graph = zeros(iterations,1);
sigf = zeros(iterations,1);
weight = zeros(iterations,3)
i = 0;
while i < 20
    R = R + 0.0005;
    i = i + 1;
    R_graph(i,1)= R;
    b = -R;
    [x, fval] = quadprog(Q,c,A,b,Aeq,beq,lb,ub);
    sigf(i,1) = fval;
    weight(i,1) = x(1,1);
    weight(i,2) = x(2,1);
    weight(i,3) = x(3,1);
end
risk = sqrt(sigf);
% Constructing points for graph (R without short selling)
R = 0;
i = 0;
iterations_wo = 14;
R_graph_wo = zeros(iterations_wo,1);
sigf_wo = zeros(iterations_wo,1);
weight_wo = zeros(iterations_wo,3);
while i < 14
    R = R + 0.00025;
    i = i + 1;
    R_graph_wo(i,1)= R;
    b = -R;
    [x, fval] = quadprog(Q,c,A,b,Aeq,beq,lb_without,ub);
    sigf_wo(i,1) = fval;
    weight_wo(i,1) = x(1,1);
    weight_wo(i,2) = x(2,1);
    weight_wo(i,3) = x(3,1);
end
risk_wo = sqrt(sigf_wo); 
%Plotting Graph
figure; hold on
a1 = plot(risk,R_graph);
a2 = plot(risk_wo,R_graph_wo,'--');
title('The Efficient Frontier (MVO)');
xlabel('Variance (\sigma)');
ylabel('Expected Return Goal (R)');
M1 = ('Short Selling');
M2 = ('Without Short Selling');
legend([a1;a2],M1,M2);
hold off
%% Part 2C
realized_return = zeros(3,1);
% Calculating realized return for Feb 2017
SPY_rr = (235.4457 - 226.634)/226.634;
GOVT_rr = (25.022 - 24.8923)/24.8923;
EEMV_rr = (51.71 - 50.72)/50.72;
realized_return(1,1) = SPY_rr;
realized_return(2,1) = GOVT_rr;
realized_return(3,1) = EEMV_rr;
R = 0.003; %Picked weights for expected return goal of 0.003
ham = weight(6,:);
ham_wo = weight_wo(12,:);
rr = dot(realized_return,ham); %Realized return of portfolio with ss
rr_wo = dot(realized_return,ham_wo); %without ss