clc; clearvars; close all;
%% load data
%load RCA_Final
load Target_TerrorNetFINAL
Nodi_v = NodiTargetVictim; 
Nodi_u = NodiTerrorVictim;
MM = Adj_Victim;
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
%% load colormap
load MappaColo2
%% reflection
K_v1 = cell(length(MM),1); % altra dim (B)
K_u1 = cell(length(MM),1); % terroristi (L)
K_v2 = cell(length(MM),1); % altra dim (B)
K_u2 = cell(length(MM),1); % terroristi (L)
%% main loop
for t = 1:length(MM)
    [K_B,K_L]=hid_hous(MM{t},2); % hidalgo-haussmann
    K_v1{t}=K_B(:,1);
    K_v2{t}=K_B(:,2);
    K_u1{t}=K_L(:,1);
    K_u2{t}=K_L(:,2);   
end
%% vedo ultimi 10 anni
Terroristi = Nodi_u{34};

for k = 34:length(Nodi_u)
    Terroristi = intersect(Terroristi,Nodi_u{k});
end

K_u1Final = zeros(length(Terroristi),15);
K_u2Final = zeros(length(Terroristi),15);
xx = 1;
for k = 34:length(Nodi_u)
    [chi, ia,ib] = intersect(Terroristi,Nodi_u{k});
    K_u1Final(:,xx)=K_u1{k}(ib);
    K_u2Final(:,xx)=K_u2{k}(ib);
    xx = xx+1;
end


% %% vedo ultimi 10 anni
% Target = Nodi_v{34:end};
% 
% for k = 34:length(Nodi_v)
%     Target = intersect(Target,Nodi_v{k});
% end
% 
% K_v1Final = zeros(length(Target),15);
% K_v2Final = zeros(length(Target),15);
% xx = 1;
% for k = 34:length(Nodi_v)
%     [chi, ia,ib] = intersect(Target,Nodi_v{k});
%     K_v1Final(:,xx)=K_v1{k}(ib);
%     K_v2Final(:,xx)=K_v2{k}(ib);
%     xx = xx+1;
% end
% 
%% fig terroristi
colori = colormap(parula(16));
for z = 1:5
    subplot(2,3,z)
    for kk = 1:16
       plot(K_u1Final(z,kk),K_u2Final(z,kk),'.','markersize',50,'color',colori(kk,:));
       hold on
    end
    hold off
    axis square
    grid on
    title(Terroristi(z))
    ylabel('HI level-2')
    xlabel('HI level-1')
    set(gca,'fontsize',12,'fontweight','bold')
end
lgn = legend(string(num2str([2004:2019]'))...
,'NumColumns',1,'location','southoutside');
title(lgn,'Years')

% %% target plot
% colori = colormap(parula(19));
% for z = 1:9
%     subplot(3,3,z)
%     for kk = 1:19
%        plot(K_v1Final(z,kk),K_v2Final(z,kk),'.','markersize',50,'color',colori(kk,:));
%        hold on
%     end
%     hold off
%     axis square
%     grid on
%     title(Target(z))
%     ylabel('HI level-2')
%     xlabel('HI level-1')
%     set(gca,'fontsize',10,'fontweight','bold')
% end
% %%
% ff = 1;
% for z = 10:19
%     subplot(4,3,ff)
%     for kk = 1:19
%        plot(K_v1Final(z,kk),K_v2Final(z,kk),'.','markersize',50,'color',colori(kk,:));
%        hold on
%     end
%     ff = ff+1;
%     hold off
%     axis square
%     grid on
%     title(Target(z))
%     ylabel('HI level-2')
%     xlabel('HI level-1')
%     set(gca,'fontsize',10,'fontweight','bold')
% end
% lgn = legend(string(num2str([2001:2019]'))...
% ,'NumColumns',1,'location','southoutside');
% title(lgn,'Years')
% 
