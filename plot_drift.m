function plot_drift(T,RR,RRfit,T_ints,OnOff,printfigs)
%{
This function plots the regions where the baroreflex is on and normalizes
each region as in Figure 2 panel e. 
Inputs - 
    T       - Matrix of times of cardiac cycles
    RR      - RR interval matrix from data 
    RRfit   - RR interval matrix from model predictions 
    T_ints  - Matrix of time intervals for on/off periods 
    OnOff   - Matrix denoting on/off periods as 1/0 corresponding to T_ints
    
Flags - 
    printfigs - Prints figures generated when set to 1. 

%}

hfig7 = figure(7);
clf
set(gcf,'units','normalized','outerposition',[0 0 .9 .9]);
hold on;
for i = 1:3
    for j = 1:4
        ind = 4*(i - 1) + j;  
        axes('position',[0.05+0.225*(j-1), 1-(0.3*i+0.05), 0.225 , 0.3])
        hold on 
        set(gca,'ytick',[],'xtick',[])  
        box on 
        % Find corresponding data and model outputs
        t = T';
        r_d = RR(:,ind); 
        r_m = RRfit(:,ind); 
        
        % Find non-Nan indices in on/off NaN
        xx = ~isnan(T_ints(:,ind)); 
        t_ints = T_ints(xx,ind); 
        oo = OnOff(xx,ind); 
        
        % Assign all "off" periods as NaN
        for k = 2:length(t_ints) 
            if oo(k-1) == 0
                y = find(t == t_ints(k-1)); 
                z = find(t == t_ints(k)); 
                t(y+1:z-1) = NaN; 
                r_d(y+1:z-1) = NaN;
                r_m(y+1:z-1) = NaN; 
            else 
                y = find(t == t_ints(k-1)); 
                z = find(t == t_ints(k));
                mean_d = mean(r_d(y:z)); 
                mean_m = mean(r_m(y:z)); 
                r_m(y:z) =  r_m(y:z)+mean_d-mean_m; 
            end 
        end
       
        plot(t,r_d,'k-','linewidth',1.5,'Markersize',6,'Markerfacecolor',[1 1 1])
        plot(t,r_m,'r-','linewidth',1.5,'Markersize',6,'Markerfacecolor',[1 1 1])
        axis([5 295 0.1 0.3])
    end
end 

if printfigs == 1
    print(hfig7,'-depsc2','fig_drift.eps')
    
    print(hfig7,'-dpng','fig_drift.png')
end 