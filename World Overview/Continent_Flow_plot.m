clc
path(path,'..\MRIO\matlabfuncs');
path(path,'..\MRIO\GeneralMatlabUtilities');
load('..\ipccaggC3_det.mat');
load('.\data\E_dir_EU28.mat');
load('.\data\Continents.mat');                                                           %load from ContinentalFlowScript.mat
NameImRegions={'Asia and Pacific imported emission','America imported emission','Europe imported emission','Africa imported emission','Middle East imported emission'};
NameDomRegions={'Asia and Pacific domestic emission','America domestic emission','Europe domestic emission','Africa domestic emission','Middle East domestic emission'};
nregion=size(NameDomRegions,2);
% set(0,'defaultfigureposition',[1300 100 1000 600])

for i=1:nregion
    figure(i)
    area(1995:2015,squeeze(Continents.ImContinents(:,i,:))');
    title(NameImRegions(i));
    ax=gca;
    ax.YLim=[0 3e+12];
    lh=legend(IPCCsecName,'Location','NorthWestOutside');
    lh.PlotChildren=lh.PlotChildren(fliplr(1:7));
end

Dom_Legend=cell(14,1);
for i=1:size(IPCCsecName,2)
    Dom_Legend(i*2-1)=strcat(IPCCsecName(i),{' Domestic Transection Emission'});
    Dom_Legend(i*2)=strcat(IPCCsecName(i),{' Direct Emission'});
end

for i=1:nregion
    figure(i+nregion)
    temp=squeeze(Continents.DomContinents(:,i,:));
    for j=1:meta.NFDSECTORS
        area((j-1)*20+1+(j*10):j*20+1+(j*10),temp((j-1)*2+1:j*2,:)');
        hold on
    end
    title(NameDomRegions(i));
    ax=gca;
    ax.XLim=[0 j*20+1+(j*10)+10];
    ax.XTick=21:30:j*20+1+(j*10)+10;
    ax.XTickLabel=IPCCsecName;
    ax.YLim=[0 2e+13];
    lh=legend('indirect emission','direct emission','Location','NorthEast');
    lh.PlotChildren=lh.PlotChildren(fliplr(1:2));
    lh=legend(Dom_Legend','Location','NorthWestOutside');
    lh.PlotChildren=lh.PlotChildren(fliplr(1:14));
end
%%

%%save images, normally commented out
% for m = 1:5
%    fname = sprintf('name%d.jpg',m);
%    saveas(figure(m),fname);
% end
