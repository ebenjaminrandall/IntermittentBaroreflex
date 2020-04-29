function plot_hyperbolas(slopes_d, slopes_m, b, r, printfigs)
%{
This function loads in vectors from optimal.mat to plot Figure 2 panel c in
the manuscript. 
Inputs - 
    slopes_d - Matrix of slopes from the data calculated in model_sol.m 
    slopes_m - Matrix of slopes from the model calculated in model_sol.m
    b        - Hyperbola parameter determining curvature 
    r        - Hyperbola parameter determining distance of intercepts from the origin

Flags - 
    printfigs - Prints figures generated when set to 1. 

%}

f =  @(x,y) x.^2 + y.^2 - b.*x.*y - r^2; 

xlims = [-r r]*10; 
ylims = [-r r]*10; 

hfig4 = figure(4);
clf
set(gcf,'units','normalized','outerposition',[0 0 .9 .9]);
hold on;
for i = 1:3
    for j = 1:4
        ind = 4*(i - 1) + j;  
        axes('position',[0.05+0.225*(j-1), 1-(0.3*i+0.05), 0.225 , 0.3])
        hold on 
        set(gca,'ytick',[],'xtick',[])  
        s_d = slopes_d(:,ind);
        s_m = slopes_m(:,ind); 
        scatter(s_d,s_m,'filled')
        plot(xlims,zeros(2,1),'k','linewidth',2.0)
        plot(zeros(2,1),ylims,'k','linewidth',2.0)  
        fimplicit(f,[xlims ylims],'g','linewidth',2.0)
        axis([xlims ylims]);
        set(gca,'Xtick',[-0.006 -0.004 -0.002 0 0.002 0.004 0.006],'Ytick',[-0.006 -0.004 -0.002 0 0.002 0.004 0.006],'Xticklabel',{''},'Yticklabel',{' '});
        grid on;
        box on;
        pbaspect([1 1 1]);
    end
end 

if printfigs == 1
    print(hfig4,'-depsc2','fig_hyperbolas.eps')
    
    print(hfig4,'-dpng','fig_hyperbolas.png')
end 

end 