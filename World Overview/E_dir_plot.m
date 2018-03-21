clc
load('..\ipccaggC3_det.mat');
tr= mriotree(meta);
E.dir=squeeze(T.Scope(1,:,:));
Lgend=meta.countrynames;

figure(1);
E.dir_countries=tr.collapseYdim(E.dir,1);
plot(1995:2015,E.dir_countries');
legend(Lgend,'Location','eastoutside');

figure(2);
C_en_EU=convertnan(xlsread('..\2. Aggregations.xlsx','Region_49_to_22','B2:W50'));
[~,Lgend_EU,~]=xlsread('..\2. Aggregations.xlsx','Region_49_to_22','B1:W1');
E.dir_EUagg=C_en_EU'*E.dir_countries;
plot(1995:2015,E.dir_EUagg');
legend(Lgend_EU,'Location','eastoutside');

figure(3);
C_en_conti=convertnan(xlsread('..\2. Aggregations.xlsx','Region_49_to_5','B2:F50'));
Lgend_conti={'Asia Pacific','America','Europe','Africa','Middle East'};
E.dir_conti=C_en_conti'*E.dir_countries;
plot(1995:2015,E.dir_conti');
legend(Lgend_conti,'Location','eastoutside');

%save E_dir_EU28.mat E