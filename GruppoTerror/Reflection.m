clc; clearvars; close all;
%% load data
load RCA_Final
%load Target_TerrorNetFINAL
Nodi_v = NodiTargetAttack; 
Nodi_u = NodiTerrorAttack;
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
anniLeg = Anni_unici;
ColoriAnno = MappaColo(1:7:end,:);
%% opzione pes Max
maxPos = 5; % top xx cattivoni o altra cat 
maxPos2 = 3; % almetro xx volte nei top cattivoni
ultimianni = 4; % vedo ultimi xx+1 anni
%% reflection
K_v = cell(length(MM),1); % altra dim (B)
K_u = cell(length(MM),1); % terroristi (L)

F1 = cell(length(MM),1); % container altra dim icdf centr1
F2 = cell(length(MM),1); % container terror icdf centr1
X1 = cell(length(MM),1);
X2 = cell(length(MM),1);

FF1 = cell(length(MM),1); % container altra dim icdf centr2
FF2 = cell(length(MM),1); % container terror icdf centr2
XX1 = cell(length(MM),1);
XX2 = cell(length(MM),1);

Str_A=zeros(length(MM),1);
Str_B=zeros(length(MM),1);


Beta_u = nan(length(MM),3); % beta reg terror
Beta_v = nan(length(MM),3); % beta reg altra

NN = cell(length(MM),1); % top terror
NN2 = cell(length(MM),1); % top terror2
VV = cell(length(MM),1); % top altra
VV2 = cell(length(MM),1); % top altra2

%% main loop
for t = 1:length(MM)
    [K_B,K_L]=hid_hous(MM{t},5); % hidalgo-haussmann
    
    [~,pos1]=sort(K_L(:,1),'descend'); % sorto terroristi
    [~,pos2]=sort(K_L(:,2),'descend');
    NN{t}=Nodi_u{t}(pos1(1:maxPos)); % prendo top 10
    NN2{t}=Nodi_u{t}(pos2(1:maxPos));
    
    [~,pos1]=sort(K_B(:,1),'descend'); % sorto altra dim
    [~,pos2]=sort(K_B(:,2),'descend');
    VV{t}=Nodi_v{t}(pos1(1:maxPos)); % prendo top 10
    VV2{t}=Nodi_v{t}(pos2(1:maxPos));
    
    [b, b_int] = regress(K_B(:,2),K_B(:,1)); % regressione centralità 1 vs2
    Beta_v(t,:)= [b, b_int];                 % per altra dim
    
    [b, b_int] = regress(K_L(:,2),K_L(:,1)); % regressione centralità 1 vs2
    Beta_u(t,:)= [b, b_int];                 % per terroristi
    
    [f,x] = ecdf(K_B(:,1),'Function','survivor'); % icdf altra centr1
    F1{t}= f;
    X1{t}= x;
    
    [f,x] = ecdf(K_L(:,1),'Function','survivor'); % icdf terror centr1
    F2{t}= f;
    X2{t}= x;
    
    [f,x] = ecdf(K_B(:,2),'Function','survivor'); % icdf altra centr2
    FF1{t}= f;
    XX1{t}= x;
    Str_B(t) = log(x(1:end-1))\log(f(1:end-1));
    
    [f,x] = ecdf(K_L(:,2),'Function','survivor'); % icdf terror centr2
    FF2{t}= f;
    XX2{t}= x;
    
    Str_A(t) = log(x(1:end-1))\log(f(1:end-1));
    % colleziono ris
    K_v{t}= K_B;
    K_u{t}= K_L;
end
%% metto a posto terroristi
NNx=[]; % top 10 terroristi centr1 nel t
NNx2=[]; % top 10 terroristi centr2 nel t
K_terror1 = [];
K_terror2 = [];
for t =1:length(NN)
 NNx = [NNx; NN{t}];
 NNx2 = [NNx2; NN2{t}];
end
% nomi unici
Chi = unique(NNx);
Chi2 = unique(NNx2);
% rank matrix 
Rank = zeros(length(Chi),length(NN));
for z = 1:length(Chi)
    for zz = 1:length(NN)
        terr = Chi(z);
        sss = find(strcmp(terr,NN{zz})==1);
        if isempty(sss)==0
            Rank(z,zz)=sss;
        end
    end
end
% rank binary
RankBin = Rank;
RankBin(RankBin>0)=1;
pezzo = sum(RankBin,2);
tolgo1 = pezzo<maxPos2;
pezzo(tolgo1)=[];


% vedo ultimi xx anno
RankRistr = Rank(:,end-ultimianni:end);
NomiX = Chi;
NomiX(sum(RankRistr,2)==0)=[];
RankRistr(sum(RankRistr,2)==0,:)=[];
% rank matrix centralità 2
Rank2 = zeros(length(Chi2),length(NN2));
for z = 1:length(Chi2)
    for zz = 1:length(NN2)
        terr = Chi2(z);
        sss = find(strcmp(terr,NN2{zz})==1);
        if isempty(sss)==0
            Rank2(z,zz)=sss;
        end
    end
end
% rank binary
RankBin2 = Rank2;
RankBin2(RankBin2>0)=1;
pezzo2 = sum(RankBin2,2);
tolgo2 = pezzo2<maxPos2;
pezzo2(tolgo2)=[];
% vedo ultimi xx anno
RankRistr2 = Rank2(:,end-ultimianni:end);
NomiX2 = Chi2;
NomiX2(sum(RankRistr2,2)==0)=[];
RankRistr2(sum(RankRistr2,2)==0,:)=[];

figure
subplot(1,2,1)
barh(pezzo)
axis tight
grid on
title('HI level-1 Ranking')
xlabel('Num. of Times Terrorists enter top 5 ranking')
Chi(tolgo1)=[];
yticks(1:length(pezzo))
yticklabels(Chi);
set(gca,'fontsize',10,'fontweight','bold')

subplot(1,2,2)
barh(pezzo2,'r')
axis tight
grid on
title('HI level-2 Ranking')
xlabel('Num. of Times Terrorists enter top 5 ranking')
Chi2(tolgo2)=[];
yticks(1:length(pezzo2))
yticklabels(Chi2);
set(gca,'fontsize',10,'fontweight','bold')

%% metto a posto altre features
VVx=[]; % top 10 altro centr1 nel t
VVx2=[]; % top 10 altro centr2 nel t
for t =1:length(VV)
 VVx = [VVx; VV{t}];
 VVx2 = [VVx2; VV2{t}];
end
% nomi unici
Chi = unique(VVx);
Chi2 = unique(VVx2);
% rank matrix
Rank = zeros(length(Chi),length(VV));
for z = 1:length(Chi)
    for zz = 1:length(VV)
        altro = Chi(z);
        sss = find(strcmp(altro,VV{zz})==1);
        if isempty(sss)==0
            Rank(z,zz)=sss;
        end
    end
end
% rank binary
RankBin = Rank;
RankBin(RankBin>0)=1;
pezzo = sum(RankBin,2);
tolgo1 = pezzo<maxPos2;
pezzo(tolgo1)=[];
% vedo ultimi xx ann1
RankRistr = Rank(:,end-ultimianni:end);
NomiX = Chi;
NomiX(sum(RankRistr,2)==0)=[];
RankRistr(sum(RankRistr,2)==0,:)=[];
% rank matrix centralità 2
Rank2 = zeros(length(Chi2),length(VV2));
for z = 1:length(Chi2)
    for zz = 1:length(VV2)
        altro = Chi2(z);
        sss = find(strcmp(altro,VV2{zz})==1);
        if isempty(sss)==0
            Rank2(z,zz)=sss;
        end
    end
end
% rank binary
RankBin2 = Rank2;
RankBin2(RankBin2>0)=1;
pezzo2 = sum(RankBin2,2);
tolgo2 = pezzo2<maxPos2;
pezzo2(tolgo2)=[];
% vedo ultimi xx anno
RankRistr2 = Rank2(:,end-ultimianni:end);
NomiX2 = Chi2;
NomiX2(sum(RankRistr2,2)==0)=[];
RankRistr2(sum(RankRistr2,2)==0,:)=[];

RankRistr(RankRistr==0)=nan;
RankRistr2(RankRistr2==0)=nan;
% figure
% subplot(1,2,1)
% p = parallelplot(RankRistr,'linewidth',3,'Markerstyle','o','Jitter',0);
% p.GroupData = NomiX;
% p.CoordinateTickLabels = num2cell(2019-ultimianni:2019);
% aa = round(linspace(5,length(MappaColo)-5,length(NomiX)));
% p.Color = MappaColo(aa,:);
% p.Title = 'Ranking position';
% ylabel('Ranking')
% subplot(1,2,2)
% p = parallelplot(RankRistr2,'linewidth',3,'Markerstyle','o','Jitter',0);
% p.GroupData = NomiX2;
% p.CoordinateTickLabels = num2cell(2019-ultimianni:2019);
% aa = round(linspace(5,length(MappaColo)-5,length(NomiX)));
% p.Color = MappaColo(aa,:);
% p.Title = 'Ranking position';
% ylabel('Ranking')
%%

figure
subplot(1,2,1)
barh(pezzo)
axis tight
grid on
title('RI level-1 Ranking')
xlabel('Num. of Times Targets enter top 5 ranking')
Chi(tolgo1)=[];
yticks(1:length(pezzo))
yticklabels(Chi);
set(gca,'fontsize',10,'fontweight','bold')
subplot(1,2,2)
barh(pezzo2,'r')
axis tight
grid on
title('RI level-2 Ranking')
xlabel('Num. of Times Targets enter top 5 rankings')
Chi2(tolgo2)=[];
yticks(1:length(pezzo2))
yticklabels(Chi2);
set(gca,'fontsize',10,'fontweight','bold')
%% plot
% figure
% subplot(2,2,1)
% for t = 1:length(MM)
%    loglog(X1{t},F1{t},'-o','linewidth',2,'Color',ColoriAnno(t,:)) 
%    hold on
% end
% axis tight
% grid on
% title('Survivor Function')
% subplot(2,2,2)
% for t = 1:length(MM)
%    loglog(X2{t},F2{t},'-o','linewidth',2,'Color',ColoriAnno(t,:)) 
%    hold on
% end
% axis tight
% grid on
% title('Survivor Function')
% 
% 
% subplot(2,2,3)
% for t = 1:length(MM)
%    loglog(XX1{t},FF1{t},'-o','linewidth',2,'Color',ColoriAnno(t,:)) 
%    hold on
% end
% axis tight
% grid on
% title('Survivor Function')
% subplot(2,2,4)
% for t = 1:length(MM)
%    loglog(XX2{t},FF2{t},'-o','linewidth',2,'Color',ColoriAnno(t,:)) 
%    hold on
% end
% axis tight
% grid on
% ll=legend(anniLeg,'NumColumns',10);
% title(ll,'Years')
% title('Survivor Function')

figure
subplot(2,1,1)
shadedErrorBar([],Beta_u(:,1),[Beta_u(:,3)-Beta_u(:,1),Beta_u(:,1)-Beta_u(:,2)]...
    ,'lineProps',{'r-o','markerfacecolor','r'})
axis tight
grid on
title('Regression coefficients of HI level-2 on level-1')
ylabel('\beta_1')
xticks(1:2:length(anniLeg))
xticklabels(anniLeg(1:2:end))
xtickangle(30)
set(gca,'fontsize',12,'fontweight','bold')
subplot(2,1,2)
shadedErrorBar([],Beta_v(:,1),[Beta_v(:,3)-Beta_v(:,1),Beta_v(:,1)-Beta_v(:,2)]...
    ,'lineProps',{'b-o','markerfacecolor','b'})
axis tight
grid on
title('Regression coefficients of RI level-2 on level-1')
ylabel('\beta_1')
xticks(1:2:length(anniLeg))
xticklabels(anniLeg(1:2:end))
xtickangle(30)
set(gca,'fontsize',12,'fontweight','bold')


%% distrib
calormap=turbo(length(FF2));
figure
subplot(2,2,1)
for u=1:length(FF2)
    loglog(FF2{u},XX2{u},'color',calormap(u,:),'linewidth',.5)
    hold on
end
grid on
axis square
title('HI level-2 survival distribution')
set(gca,'fontsize',12,'fontweight','bold')

subplot(2,2,2)
for u=1:length(FF2)
    loglog(FF1{u},XX1{u},'color',calormap(u,:),'linewidth',.5)
    hold on
end
grid on
axis square
title('RI level-2 survival distribution')
set(gca,'fontsize',12,'fontweight','bold')
lgn = legend(string(num2str([1970:1992,1994:2019]'))...
,'NumColumns',5,'location','southoutside');
title(lgn,'Years')
set(gca,'fontsize',12,'fontweight','bold')

subplot(2,2,3:4)
plot(-1+Str_A,'o-','linewidth',2,'color',[0 0 0])
hold on
plot(-1+Str_B,'^-','linewidth',2,'color',[0.7 0.7 0.7])
title('Power Law Fit Exponents')
xticks(1:2:length(Anni_unici))
xticklabels(Anni_unici(1:2:end))
xtickangle(30)
axis tight
grid on
ylabel('Exponents')
set(gca,'fontsize',12,'fontweight','bold')

