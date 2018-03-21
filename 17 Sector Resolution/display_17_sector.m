%%EU28 aggregated to have 22 economies
%%area plot of EU28, China, USA
%%Kehan He, 6 Dec 2017

% clear all
% clc
% close all

% pathes need to be changed according to users' own setting
path(path,'..\MRIO\matlabfuncs')
path(path,'..\MRIO\GeneralMatlabUtilities')
xiopath='..\MRIO\EX_v3_3_mat\';

load([xiopath, 'IOT_1995_pxp.mat'],'meta');
load('EXIO data\E_dir_17x49.mat');
load('EXIO data\E_indir_17x49.mat');
% E_indir_17x49.mat is too large to be hosted on GitHub. 
% Please contact us at xxxx@yale.edu if you wish to work on it
indir_17=EF;
clear EF;
load('sec_17_names.mat');
C_en_EU=convertnan(xlsread('..\2. Aggregations.xlsx','Region_49_to_22','B2:W50'));
[~,names_EUagg,~]=xlsread('..\2. Aggregations.xlsx','Region_49_to_22','B1:W1');
country_pick=[1 2 4];

nyear=21;
m=size(sec_17_names,2);
n_EUagg=22;

tr=mriotree(meta);

%% reorganizing direct emissions into 22 economies
dir_17=zeros(m*meta.NCOUNTRIES,meta.NCOUNTRIES,nyear);
temp=zeros(17*size(C_en_EU,2),meta.NCOUNTRIES,nyear);
E_dir_EUagg_17=zeros(17*size(C_en_EU,2),n_EUagg,nyear);
E_dir_EUagg_17_plot=zeros(m,n_EUagg,nyear);

for a=1:nyear
    dir_17(:,:,a)=tr.collapseYdim(squeeze(Dir(:,:,a)),2);
    for i=1:m
        temp(i:m:m*size(C_en_EU,2),:,a)=C_en_EU'*dir_17(i:m:m*meta.NCOUNTRIES,:,a);
    end
    for i=1:m
        E_dir_EUagg_17(i:m:m*size(C_en_EU,2),:,a)=temp(i:m:m*size(C_en_EU,2),:,a)*C_en_EU;
    end
    for i=1:m
        E_dir_EUagg_17_plot(i,:,a)=sum(E_dir_EUagg_17(i:m:m*size(C_en_EU,2),:,a));
    end
end

%% reorganizing indirect emissions into 22 economies
temp2=zeros(m*n_EUagg,m*meta.NCOUNTRIES,nyear);
temp3=zeros(m*n_EUagg,n_EUagg,nyear);
E_indir_EUagg_17=zeros(m*n_EUagg,m*n_EUagg,nyear);
E_indir_EUagg_17_plot=zeros(m,n_EUagg,nyear);
for a=1:nyear
    for i=1:m
        temp2(i:m:m*size(C_en_EU,2),:,a)=C_en_EU'*indir_17(i:m:m*meta.NCOUNTRIES,:,a);
    end
    for i=1:m
        E_indir_EUagg_17(:,i:m:m*size(C_en_EU,2),a)=temp2(:,i:m:m*meta.NCOUNTRIES,a)*C_en_EU;
    end
    for i=1:n_EUagg
        temp3(:,i,a)=sum(E_indir_EUagg_17(:,(i-1)*m+1:i*m,a),2);
    end
    for i=1:m
        E_indir_EUagg_17_plot(i,:,a)=sum(temp3(i:m:m*size(C_en_EU,2),:,a));
    end
end
%% area plot of direct and indirect emissions of China, EU28, USA by 17 sectors
for i=1:size(country_pick,2)
    figure(i)
    area(10:30,squeeze(E_indir_EUagg_17_plot(:,country_pick(i),:))');
    legend(sec_17_names);
    hold on
    area(41:61,squeeze(E_dir_EUagg_17_plot(:,country_pick(i),:))');
    lh=legend(sec_17_names);
    lh.PlotChildren=lh.PlotChildren(fliplr(1:size(sec_17_names,2)));
    ax=gca;
    ax.XLim=[0 70];
    ax.XTick=[20 51];
    ax.XTickLabel={'indirect emission', 'direct emission'};
    ax.YLim=[0 25e+12];
    title(names_EUagg(country_pick(i)));
end

%%
E_dir_EUagg_22econ=zeros(n_EUagg,n_EUagg,nyear);
E_indir_EUagg_22econ=zeros(n_EUagg,n_EUagg,nyear);
temp4=zeros(n_EUagg,m*n_EUagg,nyear);
for a=1:nyear
    for i=1:n_EUagg
        E_dir_EUagg_22econ(i,:,a)=sum(E_dir_EUagg_17((i-1)*m+1:i*m,:,a),1);
    end
    for i=1:n_EUagg
        temp4(i,:,a)=sum(E_indir_EUagg_17((i-1)*m+1:i*m,:,a),1);
    end
    for i=1:n_EUagg
        E_indir_EUagg_22econ(:,i,a)=sum(temp4(:,(i-1)*m+1:i*m,a),2);
    end    
end

for i=1:size(country_pick,2)
    figure(i+3)
    area(10:30,squeeze(E_indir_EUagg_22econ(:,country_pick(i),:))');
    legend(names_EUagg);
    hold on
    area(41:61,squeeze(E_dir_EUagg_22econ(:,country_pick(i),:))');
    ax=gca;
    ax.XLim=[0 70];
    ax.XTick=[20 51];
    ax.XTickLabel={'indirect emission', 'direct emission'};
    ax.YLim=[0 25e+12];
    title(names_EUagg(country_pick(i)));
    figure(i+6);
    E_indir_EUagg_22econ_imp=E_indir_EUagg_22econ;
    E_indir_EUagg_22econ_imp(country_pick(i),:,:)=0;
    area(10:30,squeeze(E_indir_EUagg_22econ_imp(:,country_pick(i),:))');
    legend(names_EUagg);
    hold on
    E_dir_EUagg_22econ_imp=E_dir_EUagg_22econ;
    E_dir_EUagg_22econ_imp(country_pick(i),:,:)=0;
    area(41:61,squeeze(E_dir_EUagg_22econ_imp(:,country_pick(i),:))');
    ax=gca;
    ax.XLim=[0 70];
    ax.XTick=[20 51];
    ax.XTickLabel={'indirect emission', 'direct emission'};
	title(names_EUagg(country_pick(i)));
end

%% test China construction
for a=1:m
    China_breakdown=squeeze(E_indir_EUagg_17(:,a+3*m,:));
    China_breakdown_17=zeros(17,21);
    for i=1:m
        China_breakdown_17(i,:)=sum(China_breakdown(i:m:m*n_EUagg,:));
    end
    figure(a+10);
    set(gcf,'OuterPosition',[672 550 1000 513]);
    area(China_breakdown_17');
    legend(sec_17_names,'Location','westoutside');
    title(['China indirect emission of ',sec_17_names(a)]);
end