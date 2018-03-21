function [ dir ] = get_dir( country )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
load('meta.mat');
load('data\E_dir_7x49.mat');
dir=zeros(meta.NSECTORS,21);
for i=1:49
    if strcmp(meta.countrynames(i),country)
        n=i;
    end
end

for a=1:21
    dir(:,a)=E_dir_7x49((n-1)*meta.NSECTORS+1:n*meta.NSECTORS,a);
end
