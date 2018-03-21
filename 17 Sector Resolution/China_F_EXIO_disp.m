%verify China 17 sector CBA emissions with CEEIO
%kehan, 3 Jan 2018

%%
path(path,'..\MRIO\matlabfuncs')
path(path,'..\MRIO\GeneralMatlabUtilities')
path(path,'..\MRIO\Concordances');
%xiopath='C:\Users\kh762\Desktop\Box Sync\Kehans works\Carbon Embodied Flow\Supplement Information\200-item resolution\';

%%
Z=zeros(45,45,16);
Z(:,:,1)=xlsread('CEEIO data\CEEIO_45_sectors_US$.xlsx','1992_45','C5:AU49');
Z(:,:,6)=xlsread('CEEIO data\CEEIO_45_sectors_US$.xlsx','1997_45','C5:AU49');
Z(:,:,11)=xlsread('CEEIO data\CEEIO_45_sectors_US$.xlsx','2002_45','C5:AU49');
Z(:,:,16)=xlsread('CEEIO data\CEEIO_45_sectors_US$.xlsx','2007_45','C5:AU49');

Y=zeros(45,16);
Y(:,1)=xlsread('CEEIO data\CEEIO_45_sectors_US$.xlsx','1992_45','BA5:BA49');
Y(:,6)=xlsread('CEEIO data\CEEIO_45_sectors_US$.xlsx','1997_45','BA5:BA49');
Y(:,11)=xlsread('CEEIO data\CEEIO_45_sectors_US$.xlsx','2002_45','BA5:BA49');
Y(:,16)=xlsread('CEEIO data\CEEIO_45_sectors_US$.xlsx','2007_45','BA5:BA49');

F_CO2=zeros(45,16);
F_CO2(:,1)=xlsread('CEEIO data\CEEIO_45_sectors_US$.xlsx','1992_45','C313:AU313');
F_CO2(:,6)=xlsread('CEEIO data\CEEIO_45_sectors_US$.xlsx','1997_45','C313:AU313');
F_CO2(:,11)=xlsread('CEEIO data\CEEIO_45_sectors_US$.xlsx','2002_45','C313:AU313');
F_CO2(:,16)=xlsread('CEEIO data\CEEIO_45_sectors_US$.xlsx','2007_45','C313:AU313');

%%
diff1=(Z(:,:,6)-Z(:,:,1))/5;
diff2=(Z(:,:,11)-Z(:,:,6))/5;
diff3=(Z(:,:,16)-Z(:,:,11))/5;

for n=1:5
    Z(:,:,n+1)=Z(:,:,1)+diff1*n;
    Z(:,:,n+6)=Z(:,:,6)+diff2*n;
    Z(:,:,n+11)=Z(:,:,11)+diff3*n;
end

diff1=(Y(:,6)-Y(:,1))/5;
diff2=(Y(:,11)-Y(:,6))/5;
diff3=(Y(:,16)-Y(:,11))/5;

for n=1:5
    Y(:,n+1)=Y(:,1)+diff1*n;
    Y(:,n+6)=Y(:,6)+diff2*n;
    Y(:,n+11)=Y(:,11)+diff3*n;
end

diff1=(F_CO2(:,6)-F_CO2(:,1))/5;
diff2=(F_CO2(:,11)-F_CO2(:,6))/5;
diff3=(F_CO2(:,16)-F_CO2(:,11))/5;

for n=1:5
    F_CO2(:,n+1)=F_CO2(:,1)+diff1*n;
    F_CO2(:,n+6)=F_CO2(:,6)+diff2*n;
    F_CO2(:,n+11)=F_CO2(:,11)+diff3*n;
end

x=squeeze(sum(Z,2))+Y;
%%
A=zeros(45,45,16);
for n=1:16 
    A(:,:,n)=Z(:,:,n)/(diag(x(:,n)));
end

%%
S_CO2=F_CO2./x;
M_CO2=zeros(45,16);
F_CO2_CBA=zeros(45,16);
EF_CO2=zeros(45,45,16);
for n=1:16
    M_CO2(:,n)=(S_CO2(:,n)'/(eye(45)-squeeze(A(:,:,n))))';
    F_CO2_CBA(:,n)=M_CO2(:,n).*Y(:,n);
    EF_CO2(:,:,n)=diag(M_CO2(:,n))*Z(:,:,n);
end

%%
agg_45_to_17=xlsread('..\2. Aggregations.xlsx','Sec_45_to_17','B2:R46');
[~,sec_names_17,~]=xlsread('..\2. Aggregations.xlsx','Sec_45_to_17','B1:R1');
F_CO2_CBA_17=agg_45_to_17'*F_CO2_CBA;

figure(1)
area(38:53,F_CO2_CBA_17'*1e+3);
lh=legend(sec_names_17);
lh.PlotChildren=lh.PlotChildren(fliplr(1:size(sec_names_17,2)));
ax=gca;
ax.YLim=[0 25e+12];
hold on
%%
EF_CO2_17=zeros(17,17,16);
for n=1:16
    EF_CO2_17(:,:,n)=agg_45_to_17'*EF_CO2(:,:,n)*agg_45_to_17;
end
figure(1)
area(7:22,squeeze(sum(EF_CO2_17,2))'*1e+3);
lh=legend(sec_names_17);
lh.PlotChildren=lh.PlotChildren(fliplr(1:size(sec_names_17,2)));
ax.XLim=[0 70];
ax.XTick=[20 51];
ax.XTickLabel={'indirect emission', 'direct emission'};

%%
CEEIO_China_dir_07=F_CO2_CBA_17(:,16)*1e+3;
CEEIO_China_indir_07=(squeeze(sum(EF_CO2_17,2))'*1e+3)';
CEEIO_China_indir_07=CEEIO_China_indir_07(:,16);

% save CEEIO_China_07.mat  CEEIO_China_indir_07 CEEIO_China_dir_07

%
% F=zeros(21,9800);
% %%
% for a=1:21
%     year=1994+a;
%     disp(year);
%     load([xiopath, 'IOT_', num2str(year), '_pxp.mat'], 'IO');
%     F(a,:)=IO.F(27,:);
% end
% 
% %%
% F_200=F(:,6001:6200);
% 
% %%
% path(path,'C:\Users\kh762\Desktop\Box Sync\MRIO\matlabfuncs')
% path(path,'C:\Users\kh762\Desktop\Box Sync\MRIO\GeneralMatlabUtilities')
% path(path,'C:\Users\kh762\Desktop\Box Sync\MRIO\Concordances');
% xiopath='C:\Users\kh762\Desktop\Box Sync\Kehans works\Carbon Embodied Flow\Supplement Information\200-item resolution\';
% Seventeenagg=convertnan(xlsread('EXIOBASE20p_CC17.xls','EXIOBASE20p_CC17','B2:R201'));
% F_17=F_200*Seventeenagg;
% figure(4)
% area(1995:2015,F_17);
% legend(sec_17_names);