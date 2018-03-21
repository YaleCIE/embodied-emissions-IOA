clc
clear

path(path,'..\MRIO\matlabfuncs');
path(path,'..\MRIO\GeneralMatlabUtilities');

load('..\ipccaggC3_det.mat');

C_en_EU=convertnan(xlsread('..\2. Aggregations.xlsx','Region_49_to_22','B2:W50'));
[~,Lgend,~]=xlsread('..\2. Aggregations.xlsx','Region_49_to_22','B1:W1');
tr= mriotree(meta);
nyear=size(T.DomF,3);


ImF_EU_agg=zeros(7*size(C_en_EU,2),7*size(C_en_EU,2),nyear);
temp=T.EF;

for a=1:nyear
    for i=1:7
        temp_EUagg(i:7:7*size(C_en_EU,2),:)=C_en_EU'*temp(i:7:meta.Ydim,:,a);
    end
    for i=1:7
        ImF_EU_agg(:,i:7:7*size(C_en_EU,2),a)=temp_EUagg(:,i:7:meta.Ydim,:)*C_en_EU;
    end
    for i=1:22
        ImF_EU_agg((i-1)*7+1:i*7,(i-1)*7+1:i*7,a)=0;
    end
    figure(a)
    bar3(squeeze(ImF_EU_agg(:,:,a)));
    hold on
    imagesc(squeeze(ImF_EU_agg(:,:,a)));
    colorbar
    ax=gca;
    ax.XLim=[0 153];
    ax.XLim=[0 154];
    ax.XTick=3:7:154;
    ax.XTickLabel=Lgend;   
    ax.YLim=[0 154];
    ax.YTick=3:7:154;
    ax.YTickLabel=Lgend;   
    ax.ZLim=[0 1.5e+11];
%     fname=sprintf('figure%d.jpg',a);
%     saveas(figure(a),fname);
end

% for m = 1:4
%    fname = sprintf('name%d.jpg',m);
%    saveas(figure(m),fname);
% end