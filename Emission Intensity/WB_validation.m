xiopath='C:\Users\kh762\Desktop\Box Sync\MRIO\EX_v3_3_mat\';
load([xiopath, 'IOT_1995_pxp.mat'],'meta');
meta.countries(24)={'ROU'};
[~,WB_countries,~]=xlsread('Statistics\WB_EI.xls','Data','B5:B268');
[WB_EI,~,~]=xlsread('Statistics\WB_EI.xls','Data','AN5:BG268');
WB_EI_cmp=zeros(size(meta.countrynames,1),21);
for i=1:size(WB_countries,1)
    for n=1:size(meta.countries,1)
        if strcmp(meta.countries(n),WB_countries(i))
            WB_EI_cmp(n,1:20)=WB_EI(i,:);
        end
    end
end

%% calculate difference of general emission intensities for 49 regions
%path(path,'..\GeneralMatlabUtilities');
tr=mriotree(meta);
j=4:7:343;
nyear=21;
EXIO_EI_cmp=zeros(size(meta.countries,1),nyear);
for a=1:nyear
    year=1994+a;
    disp(year);
    load([xiopath, 'IOT_', num2str(year), '_pxp.mat'], 'IO');
    GFCF=IO.Y(:,j);
    CFCtot=tr.collapseZdim(IO.F(9,:), 2);
    t=ones(1,n)-CFCtot./sum(GFCF);
    IO.Y(:,j)=GFCF*diag(t);
    EXIO_EI_cmp(:,a)=tr.collapseZdim(IO.F(27,:),2)'./tr.collapseZdim(sum(IO.Y,2),1);
end

%% plot histogram and boxplot of difference between World Bank and our calculation of emission intensities
load('Statistics\exRate_EUROstat.mat');
EXIO_EI_cmp=EXIO_EI_cmp*diag(exRate)/1e+6;
tst=WB_EI_cmp-EXIO_EI_cmp;
tst(41,:)=0;
tst(45:49,:)=0;
diff=zeros(43:20);
diff(1:40,:)=tst(1:40,1:20);
diff(41:43,:)=tst(42:44,1:20);
subplot(4,1,[1,3]);
histogram(reshape(diff,[1,size(diff,1)*size(diff,2)]),100,'Normalization','probability');
xlim([-9 1]);
ylabel=('Probability');
subplot(4,1,4);
boxplot(reshape(diff,[1,size(diff,1)*size(diff,2)]),'Orientation','horizontal')
xlabel=('difference in emission intensities of economies at different years, Kg CO2/US$');
xlim([-9 1])