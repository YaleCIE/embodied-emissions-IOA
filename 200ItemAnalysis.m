% Embodied vs Direct Emission at 200 sector resolution.
% Kehan He, January 2018

clc
close all
%% add folder matlabfuncs, GeneraMatlabUtilities, and EXIOBASE v3.3 data files into paths
% path(path,'.\MRIO\matlabfuncs')
% path(path,'.\MRIO\GeneralMatlabUtilities')
% xiopath='.\MRIO\EX_v3_3_mat\';

path(path,'C:\Users\kh762\Desktop\Box Sync\MRIO\Concordances');
path(path,'C:\Users\kh762\Desktop\Box Sync\Kehans works\Carbon Embodied Flow\Edgar Original');

load([xiopath, 'IOT_1995_pxp.mat']);
C_en=convertnan(xlsread('2. Aggregations.xlsx','xio33_hhdir','D2:E1331'));
m=meta.NSECTORS;
n=meta.NCOUNTRIES;
c=7;

j=4:7:343;
hh=zeros(3,c*n,21);

%% start loop for year 1995 to 2015 recorded in EXIOBASE v3.3
for a=1:21
    %% form a intermediate production matrix Z that account for consumption of fixed capital
    year=1994+a;
    disp(year);
    load([xiopath, 'IOT_', num2str(year), '_pxp.mat'], 'IO');
    GFCF=IO.Y(:,j);                                                 %kehan: extract out demand of items for industry sector by 49 countries (Gross Fixed Capital Formation?)
    IO.ZK=zeros(size(IO.A));
    tr= mriotree(meta);
    CFCtot=tr.collapseZdim(IO.F(9,:), 2);                          %kehan: total environmental stressor input made by consumption of fixed capital by 49 countries
    t=ones(1,n)-CFCtot./sum(GFCF);                                 %kehan: sum(GFCF) is total fixed capital formation input for industry sector by 49 countries
    %t is the percentage of input by all other items except for CFC
    IO.Y(:,j)=GFCF*diag(t);                                        %kehan: take out fixed capital formation from consumption of industry sector?
    IO.Ya=tr.collapseYdim(IO.Y,2);                                 %kehan: IO.Ya=collapse 7 sectors' demand into 1 for 49 countries
    for i=1:n
        IO.ZK(:,1+(i-1)*m:i*m)=GFCF(:,i)/sum(GFCF(:,i))*IO.F(9,1+(i-1)*m:i*m); %kehan: GFCF(:,i)/sum(GFCF(:,i)) is the share of demand on 1 item among total industry sector demand of country i
        %kehan: IO.ZK is the matrix describing input needed by each item from different countries in capital formation
        %IO.ZK=transaction matrix of capital formation
        %K-->Capital
    end
    %% form a technical coefficient matrix AK that accounts for consumption of fixed capital
    %  change emission coefficient from production based account, S, to consumption based account, M.
    xinv=ones(meta.Zdim,1)./IO.x;                                  %kehan: 1./x(final gross output vector)
    xinv(IO.x==0)=0;
    IO.AK=IO.ZK*diag(xinv);                                        %kehan: IO.AK is the coeffient matrix for capital formation's primary input
    S=IO.S(27,:);                                                  %kehan: S=IO.S(27,:) is co2 emission stressor coefficient
    
    IO.M=S/(eye(meta.Zdim)-(IO.A+IO.AK));                          %kehan: IO.M=final co2 emission per unit
    IO.Z=IO.A*diag(IO.x);                                          %kehan: IO.Z=transaction matrix of outputs
    %% allocate household consumption to respective 3 scopes and 7 sectors under IPCC specification
    
    IO.E_hh(:,a)=IO.F_hh(27,:);
    HHshares=C_en'*tr.collapseYdim(IO.F_hh,2);
    HHshares=HHshares/diag(sum(HHshares));
    hh(1,2:c:c*n,a)=HHshares(2,:).*IO.E_hh;
    hh(1,6:c:c*n,a)=HHshares(1,:).*IO.E_hh;
    
    %% save consumption based accounted emission intensities, embodied and direct emissions for year 1995 to 2015
    T.EF_item(:,:,a)=diag(IO.M)*(IO.Z+IO.ZK);                      %kehan: IO.EF=outputs+capital formation co2 emission transaction matrix
    T.CBA_item(:,:,a)=diag(IO.M)*IO.Y;
    T.M_item(:,:,a)=IO.M;
    
end

disp('Fin');