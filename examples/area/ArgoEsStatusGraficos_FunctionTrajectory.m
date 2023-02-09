function ArgoEsStatusGraficos_FunctionTrajectory(OneFloatData,GlobalDS,Limits,hPosition)
cl=parula;

if exist('hPosition','var') ==1
    hAxes=axes('position',hPosition);
else
    hAxes=axes;
end

m_proj('mercator','long',[ Limits.lon_min  Limits.lon_max],'lat',[Limits.lat_min  Limits.lat_max]);hold on;grid on;
if Limits.lat_max<55 && Limits.lon_max<15 && Limits.lat_min>15 && Limits.lon_min>-45 && isfield(GlobalDS,'batylon')==1
    m_contour(GlobalDS.batylon,GlobalDS.batylat,GlobalDS.elevations,[-1000 -1000],'color',[0.6 0.6 0.6]);hold on;grid on;
    m_contour(GlobalDS.batylon,GlobalDS.batylat,GlobalDS.elevations,[-2000 -2000],'color',[0.7 0.7 0.7]);
    m_contour(GlobalDS.batylon,GlobalDS.batylat,GlobalDS.elevations,[-4000 -4000],'color',[0.8 0.8 0.8]);
    m_usercoast(GlobalDS.filecoast,'patch',[.7 .6 .4],'edgecolor',[.7 .6 .4]);
else
    m_elev('contour',[-1000 -1000],'color',[0.6 0.6 0.6]);hold on;grid on;
    m_elev('contour',[-2000 -2000],'color',[0.7 0.7 0.7]);
    m_coast('patch',[.7 .6 .4],'edgecolor',[.7 .6 .4]);
end
m_grid('xtick',3,'ytick',3,'fontsize',7,'color',[0.5 0.5 0.5])
color=linspace(1,64,length(OneFloatData.lonsA));
if isfield(OneFloatData,'CTD0')==1
    m_plot(OneFloatData.CTD0.long,OneFloatData.CTD0.lati,'MarkerFaceColor',cl(1,:),'marker','s','MarkerEdgeColor','k','markersize',6);
end
if length(OneFloatData.lonsA)>=2
    for j=2:length(OneFloatData.lonsA)
        m_plot(OneFloatData.lonsA(j-1:j),OneFloatData.latsA(j-1:j),'color',cl(ceil(color(j)),:));
    end
end

for j=1:length(OneFloatData.lonsA)
    m_plot(OneFloatData.lonsA(j),OneFloatData.latsA(j),'color',cl(ceil(color(j)),:),'MarkerFaceColor',cl(ceil(color(j)),:),'MarkerEdgeColor',cl(ceil(color(j)),:),'marker','o','markersize',2);
end
m_plot(OneFloatData.lonsA(end),OneFloatData.latsA(end),'MarkerFaceColor',cl(ceil(color(end)),:),'marker','o','MarkerEdgeColor','k','markersize',6);
colormap(cl)
if length(OneFloatData.lonsA)==1
    caxis([1 2])
else
    caxis([1 length(OneFloatData.lonsA)])
end

hAxes.FontSize=7;
hAxes.XColor=[0.5 0.5 0.5];
hAxes.YColor=[0.5 0.5 0.5];
hAxes.LineWidth=0.1;
hC=colorbar;
if length(OneFloatData.juldsA)==1
    hC.Ticks=[1 2];
    hC.TickLabels=[datestr(OneFloatData.juldsA-1,12);datestr(OneFloatData.juldsA+1,12)];
else
    hC.Ticks=unique(round(hC.Ticks));
    hC.TickLabels=datestr(OneFloatData.juldsA(hC.Ticks),12);
end
hC.FontSize=6;
hC.Color=[0.5 0.5 0.5];
hC.LineWidth=0.1;
end