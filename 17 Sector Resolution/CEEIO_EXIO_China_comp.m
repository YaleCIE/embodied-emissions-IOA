load('CEEIO data\CEEIO_China_07.mat');
load('EXIO data\EXIO_China_07.mat');

CEEIO_China_dir_07(14)=CEEIO_China_dir_07(14)+1;
CEEIO_China_dir_07(16)=CEEIO_China_dir_07(16)+1;

CEEIO_China_indir_07(14)=CEEIO_China_indir_07(14)+1;
CEEIO_China_indir_07(16)=CEEIO_China_indir_07(16)+1;

rnk_CEEIO=zeros(17*2,1);
[~,~,rnk_CEEIO(1:17)]=unique(CEEIO_China_dir_07);
[~,~,rnk_CEEIO(18:34)]=unique(CEEIO_China_indir_07);
rnk_CEEIO(18:34)=rnk_CEEIO(18:34)+17;

rnk_EXIO=zeros(17*2,1);
[~,~,rnk_EXIO(1:17)]=unique(EXIO_China_dir_07);
[~,~,rnk_EXIO(18:34)]=unique(EXIO_China_indir_07);
rnk_EXIO(18:34)=rnk_EXIO(18:34)+17;

%%
scatter(rnk_EXIO,rnk_CEEIO);
corrcoef(rnk_EXIO,rnk_CEEIO);
P=polyfit(rnk_EXIO,rnk_CEEIO,1);
x=1:34;
yfit=P(1)*x+P(2);
hold on
plot(x,yfit);
xlabel('Ranking based on EXIOBASE database');
ylabel('Ranking based on CEEIO database');
title('Correlation of sector ranks between different databases for year 2007');
y_grid=ones(1,34)*17.5;
x_grid=1:34;
plot(y_grid,x_grid,'black.');
plot(x_grid,y_grid,'black.');