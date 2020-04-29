% Create data file
%{ 
This code loads the time courses from .txt files and generates a data.mat
file that contains matrices combining all of the data for each cardiac
cycle (CC) for each hour. Place all code in the directory containing the
.txt files. 

Outputs - 
    T   - Matrix of times of CCs
    P   - Matrix of values of pressure at each time
    SP  - Matrix of values of systolic blood pressure for each CC
    DP  - Matrix of values of diastolic blood pressure for each CC
    MAP - Matrix of values of mean arterial blood pressure for each CC
    HR  - Matrix of values of heart rate for each CC 
    RR  - Matrix of values of the RR interval of each CC

%}

clear all

%% Flags 

figureson = 1; % Plots figures if set to 1 
printfigs = 0; % Prints figures if set to 1

%% Load data

% Loads DSI data from 6pm to next day 5pm (5 minutes/hour)
load DBdnrvSHRf01BP19030.txt 
Tdata= DBdnrvSHRf01BP19030(:,1);

P0 =DBdnrvSHRf01BP19030(:,2);

load DBdnrvSHRf01BP19130.txt 
P1 =DBdnrvSHRf01BP19130(:,2);

load DBdnrvSHRf01BP19230.txt 
P2 =DBdnrvSHRf01BP19230(:,2);

load DBdnrvSHRf01BP19335.txt 
P3 =DBdnrvSHRf01BP19335(:,2);

load DBdnrvSHRf01BP19430.txt 
P4 =DBdnrvSHRf01BP19430(:,2);

load DBdnrvSHRf01BP19530.txt 
P5 =DBdnrvSHRf01BP19530(:,2);

load DBdnrvSHRf01BP181820.txt 
P6 =DBdnrvSHRf01BP181820(:,2);

load DBdnrvSHRf01BP181940.txt 
P7 =DBdnrvSHRf01BP181940(:,2);

load DBdnrvSHRf01BP182025.txt 
P8 =DBdnrvSHRf01BP182025(:,2);

load DBdnrvSHRf01BP182125.txt 
P9 =DBdnrvSHRf01BP182125(:,2);

load DBdnrvSHRf01BP182230.txt 
P10 =DBdnrvSHRf01BP182230(:,2);

load DBdnrvSHRf01BP182330.txt 
P11 =DBdnrvSHRf01BP182330(:,2);

P = [P6 P7 P8 P9 P10 P11 P0 P1 P2 P3 P4 P5]; %In order starting at 6pm 
T = (Tdata(1):0.1:Tdata(end)); % Assign new discretized time vector with 10 pt/sec
l = length(P(1,:)); 
m = length(T);

%% Calculate mean arterial pressure (MAP) and heart rate (HR)

SP  = zeros(m,l);
DP  = zeros(m,l);
MAP = zeros(m,l);
HR  = zeros(m,l);
RR  = zeros(m,l);
for i = 1:length(P(1,:))
    clearvars m sp s_locs s dp dp_locs d M HR_raw h1 h 
    
    % Diastolic BP
    [dp,dp_locs] = findpeaks(-P(:,i),'MinPeakProminence',20); 
    d = griddedInterpolant(Tdata(dp_locs),-dp,'pchip'); 
    DP(:,i) = d(T); 
    
    % Systolic BP
    [sp,sp_locs] = findpeaks(P(:,i),'MinPeakProminence',20); 
    s = griddedInterpolant(Tdata(sp_locs),sp,'pchip'); 
    SP(:,i) = s(T);
    
    % Mean arterial BP
    for j = 1:length(dp_locs)-1
        int = dp_locs(j):dp_locs(j+1);
        M(j) = trapz(Tdata(int),P(int,i))/(Tdata(int(end)) - Tdata(int(1))); 
    end 
    x = find(~isnan(M));
    t = Tdata(dp_locs(x)); 
    m = griddedInterpolant(t,M(x),'pchip');
    MAP(:,i) = m(T); 
    
    % Heart rate
    HR_raw = 1./diff(Tdata(dp_locs))*60; 
    HR_raw = [HR_raw(1); HR_raw]; 
    hsmooth = smooth(HR_raw,0.005,'rloess');
    h = griddedInterpolant(Tdata(dp_locs),hsmooth,'pchip'); 
    HR(:,i) = h(T); 
    
    % RR interval 
    RR(:,i) = 1./HR(:,i)*60; 
end 

save data.mat T P SP DP MAP HR RR 

%% Plot BP and HR for all 12 time-courses 

if figureson == 1
    plot_BP_HR_RR(T,SP,DP,MAP,HR,RR,printfigs)
end 
