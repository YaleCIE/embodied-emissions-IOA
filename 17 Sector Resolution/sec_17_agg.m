clear all
clc
close all
% path(path,'..\MRIO\matlabfuncs')
% path(path,'..\MRIO\GeneralMatlabUtilities')
xiopath1='..\200_item_embodied_emission\';
xiopath2='..\200_item_direct_emission\';
% these two paths lead to our 200 item resolution result, which is too 
% large to be hosted on GitHub. Please contact us at xxxx@yale.edu if you 
% wish to work on it
Seventeenagg=convertnan(xlsread('..\2. Aggregations.xlsx','Sec_200_to_17','B2:R201'));
m=200;
n=49;
agg_17=zeros(m*n,size(Seventeenagg,2)*n);
for i=1:n
    agg_17((i-1)*m+1:i*m,(i-1)*size(Seventeenagg,2)+1:i*size(Seventeenagg,2))=Seventeenagg;
end
EF=zeros(size(Seventeenagg,2)*n,size(Seventeenagg,2)*n,21);
Dir=zeros(size(Seventeenagg,2)*n,343);

for a=1:21
    %%
    year=1994+a;
    disp(year);
    load([xiopath1, 'indirect emission\EF_', num2str(year), '.mat']);
    EF(:,:,a)=agg_17'*cache*agg_17;
    load([xiopath2, 'direct emission\CBA_', num2str(year), '.mat']);
    Dir(:,:,a)=agg_17'*CBA;
end