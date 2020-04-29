% Calculate on fraction 
%{ 
This code performs the following: 
    - loads the optimal.mat file built from the optpars.m code;
    - calculates model predictions with the optimized parameter values; 
    - calculates on fraction and determines convergence; 
    - produces figures associated with determining on fraction as in Figure
    2 panels c through g. 

Outputs - 
    RRfit  - RR interval predictions with optimal parameter values 
    T_ints - Time intervals for on/off periods
    OnOff  - Matrix denoting which time interval is on/off corresponding to T_ints
    onfraction - Index introduced in manuscript 
    MPON   - Mean arterial blood pressures for on intervals (produced as a .txt file)
    MPOFF  - Mean arterial blood pressures for off intervals (produced as a .txt file)

Figures - 
    Hyperbola figure from plot_hyperbolas.m
    pre-On fraction figure from plot_preOF.m
    On fraction figure from plot_OF.m
    Drift figure from plot_drift.m
%}

clear all 

%% Load optimal file 

load optimal.mat 

%% Figure flags

figureson = 1; 
printfigs = 0; 
exporttotxtfile = 1; 

%% Solve model with optimal parameters

[~, slopes_d, slopes_m, ~, RRfit] = model_sol(parsopt,T,RR,MAP); 

%% Plot slopes within hyperbola

% Hyperbola parameters
b = 3.5; 
r = 0.0004; 

if figureson == 1
    plot_hyperbolas(slopes_d,slopes_m,b,r,printfigs)
end 

%% On fraction detection 

pOF = NaN(size(slopes_d)); 
for i = 1:length(pOF(1,:))
    x = find(~isnan(slopes_d(:,i))); 
    mu_d = slopes_d(x,i); 
    mu_m = slopes_m(x,i);
    for j = 1:length(mu_d)
        if mu_d(j)^2 + mu_m(j)^2 - b*mu_d(j)*mu_m(j) < r^2
            pOF(x(j),i) = 1;
        else
            pOF(x(j),i) = 0; 
        end
    end 
end 

if figureson == 1
    plot_preOF(T,RR,RRfit,pOF,printfigs)
end 
%% Plot 10 second moving window of On fraction  
OF = pOF; 
for c=1 :100
    for i = 1:length(OF(1,:))
        x = find(~isnan(OF(:,i))); 
        p = OF(x,i); 
        pp = movmean(p,101);  % 10s window 10 data points per sceond plus 1 standing for itself
        OF(x,i) = pp; 
    end 
y = find(OF >= 0.5); 
z = find(OF < 0.5); 
OF(y) = 1; 
OF(z) = 0; 
end

[MPper_nonan,n] = size(OF); 
OF_vec = reshape(OF,[1 MPper_nonan*n]); 
OFbar  = nanmean(OF_vec); 

if figureson == 1
    plot_OF(T,RR,RRfit,OF,printfigs)
end 

%% Find time intervals 

% Find all intervals of on/off times
T_ints = NaN(100,length(OF(1,:))); 
OnOff  = NaN(100,length(OF(1,:))); 
for i = 1:length(OF(1,:))
    x = find(~isnan(OF(:,i)));
    t = T(x); 
    o = OF(x,i); 
    d = diff(o); 
    dx = find(d ~= 0); 
    dx = dx + 1;
    dx = [1; dx; length(d)]; 
    for j = 1:length(dx)
        T_ints(j,i) = t(dx(j));
        OnOff(j,i) = o(dx(j)); 
    end 
end 

% Calculate on fraction 
totaltime = []; 
ontime = []; 
for i = 1:length(T_ints(1,:))
    x = find(~isnan(T_ints(:,i))); 
    t = T_ints(x,i); 
    oo = OnOff(x,i); 
    tot = t(end) - t(1); 
    totaltime = [totaltime tot]; 
    for j = 1:length(x)-1
        if oo(j) == 1
            dt = t(j+1) - t(j); 
            ontime = [ontime dt];
        end 
    end
end 
onfraction = sum(ontime)/sum(totaltime)

% Find the times, mean pressures, and rr intervals for all on/off periods 
MPsep = [];
for i = 1:length(T_ints(1,:))
    x = ~isnan(T_ints(:,i));
    t = T_ints(x,i); 
    
    clearvars MPper   
    MPper = NaN(50,3000);
    for j = 1:length(t)-1
        y = find(T == t(j));
        z = find(T == t(j+1));
        MPper(j,1:z-y+1) = MAP(y:z,i)'; 
    end
    xx = find(~isnan(MPper(:,1))); 
    MPper_nonan  = MPper(xx,:); 
    MPsep   = [MPsep; MPper_nonan]; 
end

% Find the mean pressure for the intervals that are on/off
e = []; 
for i = 1:length(OnOff(1,:))
    x = ~isnan(OnOff(:,i)); 
    o = OnOff(x,i); 
    d = diff(o);
    if length(d)>1
    for j = 1:length(d)
        if d(j) == 0 
            d(j) = d(j-1); %assigns same on/off value for previous interval
        end 
        e = [e d(j)]; 
    end
    end
end  
MPON = MPsep(e == -1,:);
MPOFF = MPsep(e == 1,:); 

[m,n] = size(MPON); 
MPworking = reshape(MPON, [1 m*n]); 
MPworking = MPworking(~isnan(MPworking)); 

[m,n] = size(MPOFF); 
MPnotworking = reshape(MPOFF,[1 m*n]); 
MPnotworking = MPnotworking(~isnan(MPnotworking)); 

if figureson == 1
    plot_drift(T,RR,RRfit,T_ints,OnOff,printfigs)
end 
    
if exporttotxtfile == 1
    save('DWKYF501on.txt','MPON','-ascii','-tabs')
    save('DWKYF501off.txt','MPOFF','-ascii','-tabs')
    
    save('DWKYF501Y.txt','MPworking','-ascii','-tabs')
    save('DWKYF501N.txt','MPnotworking','-ascii','-tabs')
end 

return 




