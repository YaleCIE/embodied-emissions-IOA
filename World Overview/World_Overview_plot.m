clc
%clear all

% before running the code, add pathes accordingly as given below in comments
% path(path,'...\matlabfuncs')
% path(path,'...\GeneralMatlabUtilities')  

% xiopath='...\EX_v3_3_mat\';
load('..\ipccaggC3_det.mat'); 
load('.\data\Geo.mat');                                                               %result from ConvertCord.m
load('.\data\E_dir_hh.mat');

C_en_EU=convertnan(xlsread('..\2. Aggregations.xlsx','Region_49_to_22','B2:W50'));
tr= mriotree(meta);
nyear=size(T.DomF,3);
[~,Lgend,~]=xlsread('..\2. Aggregations.xlsx','Region_49_to_22','B1:W1');

%%                                                                          22 Dom transection emission
figure(1);
E_dom_countries=tr.collapseYdim(squeeze(sum(T.DomF))',2)*C_en_EU;
plot(1995:2015,E_dom_countries); 
ylim([0 2.5e+13]);
legend(Lgend,'Location','eastoutside');

%%                                                                          22 Imported emission
figure(2);
E_im_countries=tr.collapseYdim(squeeze(sum(T.ImF))',2)*C_en_EU;
plot(1995:2015,E_im_countries); 
ylim([0 3.5e+12]);
legend(Lgend,'Location','eastoutside');

%%                                                                          22 Exported emission
figure(3);
temp=zeros(size(C_en_EU,2),size(C_en_EU,2),nyear);
for i=1:nyear
    temp(:,:,i)=C_en_EU'*tr.collapseYdim(tr.collapseYdim(T.EF(:,:,i),1),2)*C_en_EU;
    for j=1:size(temp)
        temp(j,j,i)=0;
    end
end
T.ExF=squeeze(sum(temp,2));
plot(1995:2015,T.ExF);
ylim([0 3.5e+12]);
legend(Lgend,'Location','eastoutside');

%%                                                                          22 direct emission
figure(5);
E_dir_countries=C_en_EU'*tr.collapseYdim(squeeze(T.ScopeT(1,:,:)),1);
plot(1995:2015,E_dir_countries);
ylim([0 1e+13]);
legend(Lgend,'Location','eastoutside');

%%                                                                          global emission percentage composition
GlobalEF=zeros(1,nyear);
for i=1:nyear
    GlobalEF(i)=sum(sum(T.EF(:,:,i)),2);
end
    GlobalEF=GlobalEF+sum(E_dir_countries);
DomPercent=zeros(size(C_en_EU,2)+2,nyear);
for i=1:nyear
    temp=tr.collapseYdim(sum(T.DomF(:,:,i),1))*C_en_EU;
    for n=1:size(C_en_EU,2)
        DomPercent(n,i)=temp(n)/GlobalEF(i);                                %transboundary percentage not counted in this plot
    end
    DomPercent(n+1,i)=sum(sum(T.ImF(:,:,i)),2)/GlobalEF(i);
end
    DomPercent(n+2,:)=sum(E_dir_countries)./GlobalEF;
figure(4);
Lgend(size(Lgend,2)+1)=cellstr('Transboundary Flow');
Lgend(size(Lgend,2)+1)=cellstr('world direct emission total');
ax=area(1995:2015,DomPercent'); 
yticks([0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1]);
ylim([0 1]);
yticklabels({'0%','10%','20%','30%','40%','50%','60%','70%','80%','90%','100%'});
lh=legend(Lgend,'Location','eastoutside');
lh.PlotChildren=lh.PlotChildren(fliplr(1:size(Lgend,2)));

% 
% %%                                                                          save images, normally commented out
% saveas(figure(1),'dom.jpg');
% saveas(figure(2),'im.jpg');
% saveas(figure(3),'ex.jpg');
% saveas(figure(5),'dir.jpg');
%saveas(figure(4),'total.jpg');