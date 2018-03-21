clc
clear

path(path,'..\MRIO\matlabfuncs')
path(path,'..\MRIO\GeneralMatlabUtilities')  
xiopath='C:\Users\kh762\Desktop\Box Sync\MRIO\EX_v3_3_mat\';
load([xiopath, 'IOT_1995_pxp.mat'], 'meta');

C_en_EU=convertnan(xlsread('..\2. Aggregations.xlsx','Region_49_to_22','B2:W50'));
[~,Lgend,~]=xlsread('..\2. Aggregations.xlsx','Region_49_to_22','B1:W1');
E_hh=zeros(meta.Ydim,21);
C_en_conti=convertnan(xlsread('..\2. Aggregations.xlsx','Region_49_to_5','B2:F50'));

for a=1:21
    %%
    year=1994+a;
    disp(year);
    load([xiopath, 'IOT_', num2str(year), '_pxp.mat'], 'IO');
    E_hh(:,a)=IO.F_hh(27,1:meta.Ydim);
    
end %for year

for i=1:7
    E_hh_EUagg(i:7:7*size(C_en_EU,2),:)=C_en_EU'*E_hh(i:7:meta.Ydim,:);
end

%save E_dir_hh.mat E_hh_EUagg E_hh