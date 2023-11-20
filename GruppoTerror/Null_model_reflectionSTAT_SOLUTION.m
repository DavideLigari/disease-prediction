clc; clearvars; close all
%% addpath
addpath('C:\Users\Alessandro\Desktop\GruppoTerror\MAX&SAM routines')
%% load net
load Target_TerrorNetFINAL
Nodi_v = NodiTargetVictim; 
Nodi_u = NodiTerrorVictim;
MM = Adj_Victim;
%% contenitore
Soluzioni = cell(length(MM),2);
%% net preproccess
for k = 1:length(MM)
    Adj = MM{k};
    N1 = Nodi_v{k};
    N2 = Nodi_u{k};
    tol1 = find(sum(Adj)==0);
    tol2 = find(sum(Adj,2)==0);
    if isempty(tol1)==0
        Adj(:,tol1)=[];
        N2(tol1)=[];
    end
    if isempty(tol2)==0
        Adj(tol2,:)=[];
        N2(tol2)=[];
    end
    MM{k}=Adj;
    Nodi_v{k}=N1;
    Nodi_u{k}=N2;
end
%% main loop per ogni tempo
tic
for t = 1:length(MM)
    t
    RCA = MM{t};
    %% max and samp
    RCA2 = [RCA;zeros(size(RCA,2),size(RCA,2))];
    RCA3 = [RCA2,zeros(size(RCA2,1),size(RCA,1))];
    output = MAXandSAM('DWCM',RCA3,[],[],0.0001,0);
    Soluzioni{t,1}=output;
    RCA4 = RCA3;
    RCA4(RCA4>0)=1;
    output = MAXandSAM('DBCM',RCA4,[],[],0.0001,0);
    Soluzioni{t,2}=output;
end
save('SoluzioniVictim.mat','Soluzioni');