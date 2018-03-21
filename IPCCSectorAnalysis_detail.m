% Embodied Emissions
% Edgar Hertwich, 10 April 2017

clear all
clc
close all
%% add folder matlabfuncs, GeneraMatlabUtilities, and EXIOBASE v3.3 data files into paths
% path(path,'.\MRIO\matlabfuncs')
% path(path,'.\MRIO\GeneralMatlabUtilities')
% xiopath='.\MRIO\EX_v3_3_mat\';

IPCCagg=convertnan(xlsread('2. Aggregations.xlsx','Sec_200_to_7','B2:H201'));
C_en=convertnan(xlsread('2. Aggregations.xlsx','xio33_hhdir','D2:E1331'));
IPCCsecName={'Energy','Transport','Materials','Industry','Services','Buildings','AFOLU'};
Orig=[IPCCsecName, 'Direct'];
load([xiopath, 'IOT_1995_pxp.mat']);
%% initiate aggregation matrix
m=meta.NSECTORS;
n=meta.NCOUNTRIES;
Elec=zeros(1,size(IO.A,1));
DomEl=zeros(size(IO.A));

for i=1:n
    Elec(1,(i-1)*m+128:(i-1)*m+141)=ones(1,141-127);
    DomEl((i-1)*m+128:(i-1)*m+141,(i-1)*m+1:i*m)=ones(141-127,m);
end


AggSec=zeros(size(IPCCagg)*n);
for i=1:n
    AggAll((i-1)*m+1:i*m,:)=IPCCagg;
    AggSec((i-1)*m+1:i*m,(i-1)*size(IPCCagg,2)+1:i*size(IPCCagg,2))=IPCCagg;
end

j=4:7:343;
c=size(IPCCagg,2);

%% start loop for year 1995 to 2015 recorded in EXIOBASE v3.3
for a=1:21
    %% form a intermediate production matrix Z that account for consumption of fixed capital
    year=1994+a;
    disp(year);
    load([xiopath, 'IOT_', num2str(year), '_pxp.mat'], 'IO');
    GFCF=IO.Y(:,j);
    IO.ZK=zeros(size(IO.A));
    tr= mriotree(meta);
    CFCtot=tr.collapseZdim(IO.F(9,:), 2);
    t=ones(1,n)-CFCtot./sum(GFCF);
    %t is the percentage of input by all other items except for CFC
    IO.Y(:,j)=GFCF*diag(t);
    IO.Ya=tr.collapseYdim(IO.Y,2);
    for i=1:n
        IO.ZK(:,1+(i-1)*m:i*m)=GFCF(:,i)/sum(GFCF(:,i))*IO.F(9,1+(i-1)*m:i*m);
    end
    %% form a technical coefficient matrix AK that accounts for consumption of fixed capital
    xinv=ones(meta.Zdim,1)./IO.x;
    xinv(IO.x==0)=0;
    IO.AK=IO.ZK*diag(xinv);
    %IO.L=inv(eye(meta.Zdim)-(IO.A+IO.AK));
    %S=IO.char(9,:)*IO.S;        %EXIOBASE2.3 GWP100
    %% change emission coefficient from production based account, S, to consumption based account, M.
    S=IO.S(27,:);
    IO.M=S/(eye(meta.Zdim)-(IO.A+IO.AK));
    IO.Z=IO.A*diag(IO.x);
    IO.EF=diag(IO.M)*(IO.Z+IO.ZK);
    %% allocate household consumption to respective scopes and sectors
    IO.E_hh=tr.collapseYdim(IO.F_hh(27,:),2);
    HHshares=C_en'*tr.collapseYdim(IO.F_hh,2);
    HHshares=HHshares/diag(sum(HHshares));
    T.hh=zeros(3,c*n,a); hht=zeros(3,7);
    T.hh(1,2:c:c*n,a)=HHshares(2,:).*IO.E_hh;
    T.hh(1,6:c:c*n,a)=HHshares(1,:).*IO.E_hh;
    T.hh(2,6:c:c*n,a)=S*diag(Elec)*IO.Ya;
    hht(1,2)=sum(T.hh(1,2:c:c*n,a),2);
    hht(1,6)=sum(T.hh(1,6:c:c*n,a),2);
    hht(2,6)=sum(T.hh(2,6:c:c*n,a),2);
    IO.Scope(1,:)=S*diag(IO.x);      
    IO.Scope(2,:)=S*diag(Elec)*IO.Z;
    IO.Scope(3,:)=sum(IO.EF)-IO.Scope(2,:);
    IO.ScopeT=IO.Scope;
    IO.ScopeT(2,:)=S*(DomEl.*IO.Z);
    IO.ScopeT(3,:)=IO.Scope(2,:)-IO.ScopeT(2,:);
    %% household emissions added to 3 scope emissions
    IO.CBA=diag(IO.M)*IO.Y;
    I.EF(1:c,1:c,a)=AggAll'*IO.EF*AggAll;
    I.EF(c+1,1:c,a)=IO.F(27,:)*AggAll+hht(1,:);
    I.EF(1:c,c+1,a)=AggAll'*sum(IO.CBA,2)+hht(1,:)';
    I.Scope(:,:,a)=IO.Scope*AggAll+hht;
    I.hh(:,:,a)=hht;
    %% national direct and embodied emissions are registered by consumption based account 
    T.EF(:,:,a)=AggSec'*IO.EF*AggSec;
    T.PF(:,:,a)=AggAll'*IO.EF*AggSec;
    T.DE(:,:,a)=IO.F(27,:)*AggSec+T.hh(1,:,a);
    %T.DE(:,:,a)=IO.char(9,:)*IO.F*AggSec+T.hh(1,:,a);
    T.CBA(:,:,a)=AggSec'*diag(IO.M)*IO.Ya;%+T.hh(:,:,a);
    T.Scope(:,:,a)=IO.Scope*AggSec+T.hh(:,:,a);
    for i=1:n
        T.DomF(:,(i-1)*c+1:i*c,a)=T.EF((i-1)*c+1:i*c,(i-1)*c+1:i*c,a);
    end
    T.ScopeT(1:3,:,a)=IO.ScopeT*AggSec;
    T.ScopeT(4,:,a)=sum(T.DomF(:,:,a),1);
    T.ScopeT(5,:,a)=sum(T.EF(:,:,a),1)-sum(T.ScopeT(2:4,:,a),1);
    T.ScopeT(1:3,:,a)=T.ScopeT(1:3,:,a)+T.hh(:,:,a);
    
    
end %for year
%% emissions embodied in trade are calculated
T.ImF=T.PF-T.DomF;

save ipccaggC3_det.mat I T meta IPCCsecName c
disp('Fin');