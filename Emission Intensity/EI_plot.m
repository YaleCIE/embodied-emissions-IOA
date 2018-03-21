clc
path(path,'.\Statistics');
load EI_results.mat

M_sec=squeeze(M_sec);
M_item=squeeze(M_item);
M_EU_sec=squeeze(M_EU_sec);

IPCCsecName={'Energy','Transport','Materials','Industry','Services','Buildings','AFOLU'};

for i=1:size(IPCCsecName,2)
    figure(i);
    boxplot(log(M_EU_sec(i:7:154,:)),1995:2015);
    
    y1=title(IPCCsecName(i));
    ax=gca;
    ax.XTick=[1,11,21];
    ax.XTickLabel=[1995,2005,2015];
    
end

