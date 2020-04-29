function plot_OF(T,RR,RRfit,OF,printfigs)
%{
This function plots the optimized model results with the on fraction after
applying the 10 second smoothing window
Inputs - 
    T       - Matrix of times of cardiac cycles
    RR      - RR interval matrix from data 
    RRfit   - RR interval matrix from model predictions 
    OF     - Percentage on fraction within the interval [window/2, tend-window/2]

Flags - 
    printfigs - Prints figures generated when set to 1. 

%}

hfig6 = figure(6);
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
        x = ~isnan(OF(:,ind));
        t = T(x)';
        r_d = RR(x,ind); 
        r_m = RRfit(x,ind);
        p = OF(x,ind); 
        fill([t; t(end:-1:1)],[0.1*ones(size(t)); 0.3*ones(size(t))],[p; p(end:-1:1)])
        hold on 
        plot(t,r_d,'k-','linewidth',1.5,'Markersize',6,'Markerfacecolor',[1 1 1])
        plot(t,r_m,'r-','linewidth',1.5,'Markersize',6,'Markerfacecolor',[1 1 1])
        axis([5 295 0.1 0.3])
    end
end 

% Assign colormap 
l = length(p);
colors = ones(l,3);
colors(:,1) = linspace(0.8,1,l)';
colors(:,2) = linspace(0.8,1,l)';
colors(:,3) = linspace(0.8,1,l)';
colormap(hfig6,colors)
caxis([0,1]);

if printfigs == 1
    print(hfig6,'-depsc2','preOF.eps')
    
    print(hfig6,'-dpng','preOF.png')
end 