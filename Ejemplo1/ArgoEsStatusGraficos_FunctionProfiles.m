function ArgoEsStatusGraficos_FunctionProfiles(OneFloatData,Limits)
%Colors
cl=parula;
color=linspace(1,64,size(OneFloatData.salsA,2));

%Postions
RepresentaOxigen=0;
hPTPosition=[0.14 0.05 0.30 0.42];
hPSPosition=[0.56 0.05 0.30 0.42];
if isfield(OneFloatData,'oxysA')
    if length(OneFloatData.oxysA)==length(OneFloatData.presA)
        RepresentaOxigen=1;
        hPTPosition=[0.05 0.05 0.27 0.42];
        hPSPosition=[0.37 0.05 0.27 0.42];
        hPOPosition=[0.69 0.05 0.27 0.42];
    end
end

%% Temperature
if exist('hPTPosition','var') ==1
    hT=axes('position',hPTPosition);
elseif RepresentaOxigen==0
    hT=subplot(1,2,1);set(hT,'clipping','on');
else
    hT=subplot(1,3,1);set(hT,'clipping','on');
end

%CTD profile in the case is was sampled during deployment.
if isfield(OneFloatData,'CTD0')==1
    plot(OneFloatData.CTD0.ptmp,-OneFloatData.CTD0.pres,':','color',cl(1,:),'linewidth',3);hold on
end
%Fist profile
plot(OneFloatData.ptemsA(:,1),-OneFloatData.presA(:,1),'color',cl(ceil(color(1)),:),'linewidth',1.25);hold on
%Following profiles
for j=1:size(OneFloatData.temsA,2)
    plot(OneFloatData.ptemsA(:,j),-OneFloatData.presA(:,j),'color',cl(ceil(color(j)),:),'linewidth',1.25);
end
%Last profile
plot(OneFloatData.ptemsA(:,end),-OneFloatData.presA(:,end),'color',cl(ceil(color(end)),:),'linewidth',3);grid on
plot(OneFloatData.ptemsA(:,end),-OneFloatData.presA(:,end),'color','k','linewidth',1);grid on

colormap(parula)
if size(OneFloatData.temsA,2)==1
    caxis([1 2])
else
    caxis([1 size(OneFloatData.temsA,2)])
end

axis([Limits.minT Limits.maxT -Limits.maxP 0])
hT.FontSize=7;
hT.TitleFontWeight='normal';
hT.XColor=[0.5 0.5 0.5];
hT.YColor=[0.5 0.5 0.5];
hT.ClippingStyle='rectangle';
title('Potential temperature [ITS-90]','fontsize',8,'VerticalAlignment','baseline')

%% Salinity
if exist('hPSPosition','var') ==1
    hS=axes('position',hPSPosition);
elseif RepresentaOxigen==0
    hS=subplot(1,2,2);set(hS,'clipping','on');
else
    hS=subplot(1,3,2);set(hS,'clipping','on');
end

%CTD profile in the case is was sampled during deployment.
if isfield(OneFloatData,'CTD0')==1
    plot(OneFloatData.CTD0.salt,-OneFloatData.CTD0.pres,':','color',cl(1,:),'linewidth',3);hold on
end
%Fist profile
plot(OneFloatData.salsA(:,1),-OneFloatData.presA(:,1),'color',cl(ceil(color(1)),:),'linewidth',1.25);hold on
%Following profiles
for j=1:size(OneFloatData.temsA,2)
    plot(OneFloatData.salsA(:,j),-OneFloatData.presA(:,j),'color',cl(ceil(color(j)),:),'linewidth',1.25);
end
%Last profile
plot(OneFloatData.salsA(:,end),-OneFloatData.presA(:,end),'color',cl(ceil(color(end)),:),'linewidth',3);grid on
plot(OneFloatData.salsA(:,end),-OneFloatData.presA(:,end),'color','k','linewidth',1);grid on

colormap(parula)
if size(OneFloatData.temsA,2)==1
    caxis([1 2])
else
    caxis([1 size(OneFloatData.temsA,2)])
end
axis([Limits.minS Limits.maxS -Limits.maxP 0])
hS.FontSize=7;
hS.TitleFontWeight='normal';
hS.XColor=[0.5 0.5 0.5];
hS.YColor=[0.5 0.5 0.5];
hS.ClippingStyle='rectangle';
title('Salinity [psu]','fontsize',8,'VerticalAlignment','baseline')

%% Oxygen
if RepresentaOxigen==1
    if exist('hPOPosition','var') ==1
        hO=axes('position',hPOPosition);
    elseif RepresentaOxigen==0
        hO=subplot(1,2,3);set(hO,'clipping','on');
    else
        hO=subplot(1,3,3);set(hO,'clipping','on');
    end

    %Fist profile
    plot(OneFloatData.oxysA(:,1),-OneFloatData.presA(:,1),'color',cl(ceil(color(1)),:),'linewidth',1.25);hold on
    %Following profiles
    for j=1:size(temsA,2)
        plot(OneFloatData.oxysA(:,j),-OneFloatData.presA(:,j),'color',cl(ceil(color(j)),:),'linewidth',1.25);
    end
    %Last profiles
    plot(OneFloatData.oxysA(:,end),-OneFloatData.presA(:,end),'color',cl(ceil(color(end)),:),'linewidth',3);grid on
    plot(OneFloatData.oxysA(:,end),-OneFloatData.presA(:,end),'color','k','linewidth',1);grid on

    colormap(parula)
    caxis([1 size(OneFloatData.temsA,2)])
    axis([Limits.minO Limits.maxO -Limits.maxP 0])
    hO.FontSize=7;
    hO.TitleFontWeight='normal';
    hO.XColor=[0.5 0.5 0.5];
    hO.YColor=[0.5 0.5 0.5];
    hO.ClippingStyle='rectangle';
    title('Dissolved oxygen [micromole/kg]','fontsize',8,'VerticalAlignment','baseline')
end
