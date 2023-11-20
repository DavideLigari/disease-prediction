clc; clearvars; close all
%% addpath
addpath('C:\Users\Alessandro\Desktop\GruppoTerror\MAX&SAM routines')
%% load net
load Target_TerrorNetFINAL
Nodi_v = NodiTargetAttack{end}; 
Nodi_u = NodiTerrorAttack{end};
MM = Adj_Attack{end};
nbin = 30;
%% HH reale
[K_Terr_real,K_Targ_real]=hid_hous(MM,2); % hidalgo-haussmann
RI1 = K_Targ_real(:,1);
RI2 = K_Targ_real(:,2);
HI1 = K_Terr_real(:,1);
HI2 = K_Terr_real(:,2);
%% sort link e cut
I = find(MM>0);
Link = MM(I);
[LinkOrder, posLink]=sort(Link);
%% contenitori
RI2_cont = zeros(size(Link,1),size(RI1,1));
HI2_cont = zeros(size(Link,1),size(HI1,1));

RI2_center = zeros(size(Link,1),nbin);
HI2_center = zeros(size(Link,1),nbin);

RI2_count = zeros(size(Link,1),nbin);
HI2_count = zeros(size(Link,1),nbin);

cumulo = zeros(size(Link,1));
%% main
for k = 1:length(LinkOrder)
    MM(I(posLink(k)))=0;
    nnz(MM)
    cumulo(k) = sum(LinkOrder(1:k));
    [K_Terr_real,K_Targ_real]=hid_hous(MM,2); % hidalgo-haussmann
    RI1_dis = K_Targ_real(:,1);
    RI2_dis = K_Targ_real(:,2);
    HI1_dis = K_Terr_real(:,1);
    HI2_dis = K_Terr_real(:,2);
    
    RI2_cont(k,:)=RI2_dis;
    HI2_cont(k,:)=HI2_dis;
    
    [counts,centers] = hist(RI2_dis,nbin);
    RI2_count(k,:)=counts;
    RI2_center(k,:)=centers;
    
    [counts,centers] = hist(HI2_dis,nbin);
    HI2_count(k,:)=counts;
    HI2_center(k,:)=centers;
end
%% hist3

