% Optimize parameter values 
%{ 
This code loads the data.mat file created from createdatafile.m and
estimates parameter values tau and alpha by minimizing relative error
between the standard deviations of the model and the data via the function
model_sol.m 

Outputs - 
    parsopt - Optimal parameter values determined from joint GA and fmincon
    optimization schemes

The results are saved in the optimal.mat file. 
%} 

clear all

%% Load data 

load data.mat

%% Parameter estimation 

% Nominal parameter values 
pars0 = [5; 0.001]; 

% Parameter bounds 
LB = [1; 0.0005];
UB = [10; 0.005];

% Anonymous function for model
fun = @(par) model_sol(par,T,RR,MAP);

% Optimize with genetic algorithm
ga_Opts = optimoptions('ga','PopulationSize',100,'Display','iter','MaxStallGenerations',3, 'UseParallel',true);
[parsopt_ga,J_ga] = ga(fun,length(pars0),[],[],[],[],LB,UB,[],ga_Opts); 

% Optimize with fmincon
opt    = optimset('Display','Iter', 'UseParallel',true); 
[parsopt_fmincon,J_fmincon] = fmincon(fun,parsopt_ga,[],[],[],[],LB,UB,[],opt); 

% Take the parameters with the lowest value of the cost functional
if J_ga < J_fmincon
    parsopt = parsopt_ga;
else
    parsopt = parsopt_fmincon; 
end

save optimal.mat 
