function plot_BP_HR_RR(T,SP,DP,MAP,HR,RR,printfigs)
%{
This function loads in matrices built from createdatafile.m and plots blood
pressure (BP), heart rate (HR), and RR interval (RR) figures as in
Figure 2 panels a and b in the manuscript. 
Inputs - 
    T     - Matrix of times for cardiac cycles
    SP    - Systolic blood pressure matrix 
    DP    - Diastolic blood pressure matrix 
    MAP   - Mean arterial blood pressure matrix 
    HR    - Heart rate matrix
    RR    - RR interval matrix

Flags - 
    printfigs - Prints figures generated when set to 1. 

%}

% Blood pressure 
hfig1 = figure(1);
clf
set(gcf,'units','normalized','outerposition',[0 0 .9 .9]); 
for i = 1:3
    for j = 1:4
        ind = 4*(i - 1) + j;  
        hold on 
        axes('position',[0.05+0.225*(j-1), 1-(0.3*i+0.05), 0.225 , 0.3])
        set(gca,'ytick',[],'xtick',[]) 
        box on
        hold on      
        t = T; 
        s = SP(:,ind); 
        d = DP(:,ind); 
        m = MAP(:,ind); 
        f = fill([t t(end:-1:1) t(1)],[s' d(end:-1:1)' s(1)],0.5*[1 1 1]);
        set(f,'Edgecolor','none');
        plot(t,m,'k-','linewidth',1.5,'Markersize',6,'Markerfacecolor',[1 1 1])
        set(gca,'fontsize',12,'Xlim',[0 300],'Ylim',[50 250]);
    end
end 
    
% Heart rate 
hfig2 = figure(2); 
clf
set(gcf,'units','normalized','outerposition',[0 0 .9 .9]); 
for i = 1:3
    for j = 1:4
        ind = 4*(i - 1) + j;  
        hold on 
        axes('position',[0.05+0.225*(j-1), 1-(0.3*i+0.05), 0.225 , 0.3])
        set(gca,'ytick',[],'xtick',[]) 
        box on
        hold on   
        t = T;
        h = HR(:,ind); 
        plot(t,h,'r-','linewidth',1.5,'Markersize',6,'Markerfacecolor',[1 1 1])
        set(gca,'fontsize',12,'Xlim',[0 300],'Ylim',[305 505]);
    end
end 

% RR interval 
hfig3 = figure(3); 
clf
set(gcf,'units','normalized','outerposition',[0 0 .9 .9]); 
for i = 1:3
    for j = 1:4
        ind = 4*(i - 1) + j;  
        hold on 
        axes('position',[0.05+0.225*(j-1), 1-(0.3*i+0.05), 0.225 , 0.3])
        set(gca,'ytick',[],'xtick',[]) 
        box on
        hold on 
        t = T;
        r = RR(:,ind); 
        plot(t,r,'r-','linewidth',1.5,'Markersize',6,'Markerfacecolor',[1 1 1])
        set(gca,'fontsize',12,'Xlim',[0 300],'Ylim',[.1 .2]);
    end
end 

if printfigs == 1
    print(hfig1,'-depsc2','fig_MAP.eps')
    print(hfig2,'-depsc2','fig_HR.eps')
    print(hfig3,'-depsc2','fig_RR.eps')
    
    print(hfig1,'-dpng','fig_MAP.png')
    print(hfig2,'-dpng','fig_HR.png')
    print(hfig3,'-dpng','fig_RR.png')
end 
end 