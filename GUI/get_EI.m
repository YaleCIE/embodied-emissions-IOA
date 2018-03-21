function [ EI ] = get_EI( country )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
load('meta.mat');
load('data\EI_7x49.mat');
EI=zeros(meta.NSECTORS,21);
for i=1:49
    if strcmp(meta.countrynames(i),country)
        n=i;
    end
end

for a=1:21
    EI(:,a)=EI_7x49((n-1)*meta.NSECTORS+1:n*meta.NSECTORS,a);
end
