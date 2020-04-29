function [J,slopes_d,slopes_m,sigma,RRfit] = model_sol(par,T,RR,MAP)
%{
Solves the model and calculates the cost functional

Inputs:
    pars -      Parameter vector of length 2
    T    -      Matrix of times of cardiac cycles 
    RR   -      RR interval matrix 
    MAP  -      Mean arterial pressure matrix

Outputs: 
    J -         Solution to the cost functional
    slopes_d -  Matrix of slope of lines of regression within a window T
    for data
    slopes_m -  Matrix of slope of lines of regression within a window T
    for model output
    sigma    -  Standard deviations 
    RRfit    -  RR interval model predictions
%}
%% Parameters

tau   = par(1);
alpha = par(2);

%% Solution to piecewise constant DE

MAPbar = mean(MAP); 
RRbar  = mean(RR);
RRfit      = zeros(size(RR)); 
RRfit(1,:) = RR(1,:); 
t = T; 
dt = 0.1; 

for i = 1:length(RR(1,:))
    m = MAP(:,i); 
    for j = 2:length(t)
        RRfit(j,i) = RRfit(j-1,i)*exp(-dt/tau) + (1 - exp(-dt/tau))*(alpha*m(j-1) + RRbar(i) - alpha*MAPbar(i)); 
    end 
end 

%% Determine on fraction
%{
Compares the change in RR interval of both the model output and the data 
over a time interval T
%}

window = 10; 

slopes_d = NaN(size(RR));
slopes_m = NaN(size(RR));
t = T;
y   = find(t >= window/2 & t <= t(end)-window/2);
for i=1:length(RR(1,:))   
    r_d = RR(:,i); 
    r_m = RRfit(:,i);    
    for j = 1:length(y)
        x_new = find(t >= t(y(j))-window/2 & t <= t(y(j))+window/2); 
        t_wind   = t(x_new);
        r_d_wind = r_d(x_new); 
        r_m_wind = r_m(x_new); 
        s_d = polyfit(t_wind',r_d_wind,1); 
        s_m = polyfit(t_wind',r_m_wind,1); 
        slopes_d(y(j),i) = s_d(1); 
        slopes_m(y(j),i) = s_m(1); 
    end
end

[m,n] = size(slopes_d); 
mu_d = reshape(slopes_d,[1 m*n]); 
mu_m = reshape(slopes_m,[1 m*n]); 

sigma_d = nanstd(mu_d); 
sigma_m = nanstd(mu_m);
sigma = [sigma_d; sigma_m]; 

J = abs(sigma_m/sigma_d - 1);

end 