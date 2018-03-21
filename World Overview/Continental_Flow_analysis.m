clc
clear all

path(path,'..\MRIO\matlabfuncs');
path(path,'..\MRIO\GeneralMatlabUtilities');
load('..\ipccaggC3_det.mat');
load('data\E_dir_EU28.mat');
load('data\E_dir_hh.mat');

tr= mriotree(meta);
nyear=size(T.ImF,3);
C_en=convertnan(xlsread('..\2. Aggregations.xlsx','Region_49_to_5','B2:F50'));
Continents.ImCountries=zeros(meta.NFDSECTORS,meta.NCOUNTRIES,nyear);
Continents.ImContinents=zeros(meta.NFDSECTORS,size(C_en,2),nyear);
Continents.DomCountries=zeros(meta.NFDSECTORS*2,meta.NCOUNTRIES,nyear);
Continents.DomContinents=zeros(meta.NFDSECTORS*2,size(C_en,2),nyear);
nregion=size(C_en,2);

%%                                                                          draw 5 regions' imported emission by 7 sectors over 21 years
for a=1:nyear
    Continents.ImCountries(:,:,a)=tr.collapseYdim(T.ImF(:,:,a),2);
    Continents.ImContinents(:,:,a)=Continents.ImCountries(:,:,a)*C_en;
end
%%

%%                                                                          draw 5 regions' domestic emission by 7 sectors over 21 years
%E.dir=E.dir+E_hh;                                                           %adding household emission to direct emission
for a=1:nyear
    Continents.DomCountries(1:2:14,:,a)=tr.collapseYdim(T.DomF(:,:,a),2);
    Continents.DomContinents(1:2:14,:,a)=Continents.DomCountries(1:2:14,:,a)*C_en;
    for i=1:7
        Continents.DomCountries(i*2,:,a)=E.dir(i:7:343,a)';
        Continents.DomContinents(i*2,:,a)=E.dir(i:7:343,a)'*C_en;
    end
end

%%adding direct emission as a total sum in the 8th row  
% Continents.DomCountries(8,:,:)=tr.collapseYdim(squeeze(T.ScopeT(1,:,:)),1);
% Continents.DomContinents(8,:,:)=C_en'*squeeze(Continents.DomCountries(8,:,:));
% IPCCsecName(8)=cellstr('Direct Emission');

%save Continents.mat Continents