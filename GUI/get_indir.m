function [ indir ] = get_indir( country_in,country_out )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
load('meta.mat');
load('data\E_indir_7x49.mat');
indir=zeros(meta.NSECTORS,meta.NSECTORS,21);
for i=1:49
    if strcmp(meta.countrynames(i),country_in)
        in=i;
    end
    if strcmp(meta.countrynames(i),country_out)
        out=i;
    end
end

for a=1:21  
    indir(:,:,a)=E_indir_7x49((in-1)*meta.NSECTORS+1:in*meta.NSECTORS,(out-1)*meta.NSECTORS+1:out*meta.NSECTORS,a);
end
