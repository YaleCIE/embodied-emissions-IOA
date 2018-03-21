clc

% before running the code, add pathes accordingly as given below in comments

% path(path,'..\MRIO\matlabfuncs')
% path(path,'..\MRIO\GeneralMatlabUtilities')  
% xiopath='..\MRIO\EX_v3_3_mat\';
path(path,'.\Statistics');
load('..\ipccaggC3_det.mat');
tr= mriotree(meta);
m=meta.NSECTORS;
n=meta.NCOUNTRIES;
nyear=21;
j=4:7:343;
M_item=zeros(1,m*n,nyear);
M_sec=zeros(1,7*n,nyear);

IPCCagg=convertnan(xlsread('..\2. Aggregations.xlsx','Sec_200_to_7','B2:H201'));
C_en_EU=convertnan(xlsread('..\2. Aggregations.xlsx','Region_49_to_22','B2:W50'));
M_EU_sec=zeros(1,7*size(C_en_EU,2),nyear);

AggSec=zeros(size(IPCCagg)*n);                                              
for i=1:n
    AggSec((i-1)*m+1:i*m,(i-1)*size(IPCCagg,2)+1:i*size(IPCCagg,2))=IPCCagg;
end

%%
for a=1:nyear
    year=1994+a;
    disp(year);
    load([xiopath, 'IOT_', num2str(year), '_pxp.mat'], 'IO');
    GFCF=IO.Y(:,j);
    IO.ZK=zeros(size(IO.A));
    CFCtot=tr.collapseZdim(IO.F(9,:), 2);
    t=ones(1,n)-CFCtot./sum(GFCF);                                 
    IO.Y(:,j)=GFCF*diag(t);
    IO.Ya=tr.collapseYdim(IO.Y,2);
    for i=1:n
        IO.ZK(:,1+(i-1)*m:i*m)=GFCF(:,i)/sum(GFCF(:,i))*IO.F(9,1+(i-1)*m:i*m);
    end
    xinv=ones(meta.Zdim,1)./IO.x;
    xinv(IO.x==0)=0;
    IO.AK=IO.ZK*diag(xinv);
    S=IO.S(27,:);  
    M_item(:,:,a)=S/(eye(meta.Zdim)-(IO.A+IO.AK));
  
    IO.Z=IO.A*diag(IO.x);
    Agg_x=AggSec'*IO.x;
    Agg_xinv=ones(meta.Ydim,1)./Agg_x;
    Agg_ZplusZK=AggSec'*(IO.ZK+IO.Z)*AggSec;
    IO.Agg_A_AK=Agg_ZplusZK*diag(Agg_xinv);
    Agg_F=S.*IO.x'*AggSec;
    Agg_S=Agg_F./Agg_x';
    M_sec(:,:,a)=Agg_S/(eye(meta.Ydim)-(IO.Agg_A_AK));               
 
    for i=1:7
        temp(:,i:7:7*size(C_en_EU,2))=Agg_ZplusZK(:,i:7:meta.Ydim)*C_en_EU;
    end
    for i=1:7
        AggEU_ZplusZK(i:7:7*size(C_en_EU,2),:)=C_en_EU'*temp(i:7:meta.Ydim,:);
    end
    for i=1:7
        AggEU_x(i:7:7*size(C_en_EU,2),:)=C_en_EU'*Agg_x(i:7:meta.Ydim);
    end
    AggEU_xinv=ones(size(AggEU_x,1),1)./AggEU_x;
    IO.AggEU_A_AK=AggEU_ZplusZK*diag(AggEU_xinv);
    for i=1:7
        AggEU_F(i:7:7*size(C_en_EU,2))=Agg_F(i:7:meta.Ydim)*C_en_EU;
    end
    AggEU_S=AggEU_F./AggEU_x';
    M_EU_sec(:,:,a)=AggEU_S/(eye(7*size(C_en_EU,2))-IO.AggEU_A_AK); 

end
M_item=M_item/1e+6;
M_sec=M_sec/1e+6;
M_EU_sec=M_EU_sec/1e+6;

 save EI_results.mat M_item M_sec M_EU_sec
