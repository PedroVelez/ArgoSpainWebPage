function createDataSetStatus_FunctionTS(OneFloatData,GlobalDS,Limits,hPosition);

%Colors
cl=parula;
color=linspace(1,length(cl),size(OneFloatData.sals,2));

fprintf('TS, ')

%Position
if exist('hPosition','var') ==1
    hAxes=axes('position',hPosition,'clipping','on');
else
    hAxes=axes('clipping','on');
end

%Add the climatology
if Limits.lat_min <-90  ;Limits.lat_min = -90;end
if Limits.lat_min > 90  ;Limits.lat_min = 90;end
if Limits.lon_min <-180 ;Limits.lon_min = -180;end
if Limits.lon_max > 180 ;Limits.lon_max = 180;end
if isfield(GlobalDS,'Cli')==1
    I=find(GlobalDS.Cli.lon>Limits.lon_min & GlobalDS.Cli.lon<Limits.lon_max);
    J=find(GlobalDS.Cli.lat>Limits.lat_min & GlobalDS.Cli.lat<Limits.lat_max);
    K=find(GlobalDS.Cli.pre>0 & GlobalDS.Cli.pre<Limits.maxP+50);
    if isempty(I)==0 && isempty(J)==0 && isempty(K)==0
        CLIis=1;
        CLIlat=GlobalDS.Cli.lat(J);
        CLIlon=GlobalDS.Cli.lon(I);
        CLIpre=GlobalDS.Cli.pre(K);
        CLIsal=GlobalDS.Cli.sal(I,J,K);
        CLItem=GlobalDS.Cli.tem(I,J,K);
        CLInombre=GlobalDS.Cli.nombre;
    end
    htsl0=plot(CLIsal(:),CLItem(:),'o','markersize',4,'markeredge',[0.75 0.75 0.75],'markerfacecolor',[0.65 0.65 0.65]);hold on
end
tr=0:0.5:30;sr=34.:.1:39.;[s,t]=meshgrid(sr,tr); sg = sw_dens(s,t,zeros(size(t))) - 1000;
sg(t>Limits.maxT+1)=NaN;sg(t<Limits.minT-1)=NaN;sg(s>Limits.maxS+0.5)=NaN;sg(s<Limits.minS-0.5)=NaN;
[~,h]=contour(sr,tr,sg,22.5:1:29.5,':');set(h,'edgecolor',[.5 .5 .5]);hold on
[c,h]=contour(sr,tr,sg,22:1:30);        set(h,'edgecolor',[.5 .5 .5]);
hCL=clabel(c,'color',[.5 .5 .5],'fontsize',6,'backgroundcolor','w');
for ii=1:2:length(hCL)
    hCL(ii).Marker='none';
end

axis([Limits.minS Limits.maxS Limits.minT Limits.maxT]);

%Add Profiles
%CTD profile in the case is was sampled during deployment.
if isfield(OneFloatData,'CTD0')==1
    hCTD0=plot(OneFloatData.CTD0.salt,OneFloatData.CTD0.ptmp,':','color',cl(1,:),'linewidth',3);hold on
end

%Fist profile
plot(OneFloatData.sals(:,1),OneFloatData.ptms(:,1),'color',cl(ceil(color(1)),:),'linewidth',1.25);hold on

%Following profiles
for j=2:size(OneFloatData.sals,2)
    plot(OneFloatData.sals(:,j),OneFloatData.ptms(:,j),'color',cl(ceil(color(j)),:),'linewidth',1.25);
end

%Last profiles
plot(OneFloatData.sals(:,end),OneFloatData.ptms(:,end),'color',cl(ceil(color(end)),:),'linewidth',3);
hlp=plot(OneFloatData.sals(:,end),OneFloatData.ptms(:,end),'color','k','linewidth',1);

if isfield(OneFloatData,'CTD0')==1
    hl=legend([hCTD0,hlp],sprintf('Perfil CTD'),sprintf('Último perfil: %s',datestr(OneFloatData.julds(end),1)),'Location','northwest');
else
    hl=legend(hlp,sprintf('Último perfil: %s',datestr(OneFloatData.julds(end),1)),'Location','northwest');
end
hl.Box='off';

colormap(cl)
if size(OneFloatData.sals,2)==1
    caxis([1 2])
else
    caxis([1 size(OneFloatData.sals,2)])
end
xlabel('Salinity [psu]','fontsize',8)
ylabel('Potential temperature [ITS-90]','fontsize',8)
hAxes.ClippingStyle='rectangle';
hAxes.FontSize=7;
hAxes.XColor=[0.5 0.5 0.5];
hAxes.YColor=[0.5 0.5 0.5];
end
