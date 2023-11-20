clc; clearvars; close all
%% addpath
addpath('C:\Users\Alessandro\Desktop\GruppoTerror\MAX&SAM routines')
%% load net
load Target_TerrorNetFINAL
Nodi_v = NodiTargetVictim; 
Nodi_u = NodiTerrorVictim;
MM = Adj_Victim;
load SoluzioniVictim
%load pezzoNull_2
%% optioni
N = 2; % hidalgo Hausmann al 3-ordine
NULL_NEW_NUMB = 1000; % number of null networks
%% kernel density
FU_kernel_mov = zeros(length(MM),201);
XU_kernel_mov = zeros(length(MM),201);
FV_kernel_mov = zeros(length(MM),201);
XV_kernel_mov = zeros(length(MM),201);

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
%% Contenitori
K_v_NULL = cell(length(MM),1); % altra dim (B)
K_u_NULL = cell(length(MM),1); % terroristi (L)

K_v_REAL = cell(length(MM),1); % altra dim (B)
K_u_REAL = cell(length(MM),1); % terroristi (L)


Z_SCORE_v = cell(length(MM),1); % altra dim (B)
Z_SCORE_u = cell(length(MM),1); % terroristi (L)
%% main loop per ogni tempo
tic
for t = 1:length(MM)
    t
    RCA = MM{t};
    [K_B_real,K_L_real]=hid_hous(MM{t},N); % hidalgo-haussmann
    K_u_REAL{t} = K_B_real;
    K_v_REAL{t} = K_L_real;
       
    KK_u_null2= zeros(size(RCA,1),N,NULL_NEW_NUMB);
    KK_v_null2= zeros(size(RCA,2),N,NULL_NEW_NUMB);
    %% max and samp
    RCA2 = [RCA;zeros(size(RCA,2),size(RCA,2))];
    RCA3 = [RCA2,zeros(size(RCA2,1),size(RCA,1))];
    output = Soluzioni{t,1};
    %% sampling   
    for ng = 1:NULL_NEW_NUMB             
       Wext=samplingAll(output,'DWCM');
       RCA_null = Wext(1:size(RCA,1),1:size(RCA,2));
       %% faccio Hidalgo Hausman su rete nulla
       [K_B,K_L]=hid_hous(RCA_null,N); % hidalgo-haussmann
              
       KK_u_null2(:,:,ng) = K_B;
       KK_v_null2(:,:,ng) = K_L;   
    end
    
    Z_u = (K_B_real - mean(KK_u_null2,3))./std(KK_u_null2,1,3);
    Z_u(isnan(Z_u))=0;
    Z_u(isinf(Z_u))=0;
    Z_v = (K_L_real - mean(KK_v_null2,3))./std(KK_v_null2,1,3);
    Z_v(isnan(Z_v))=0;
    Z_v(isinf(Z_v))=0;
    Z_SCORE_u{t}=Z_u;
    Z_SCORE_v{t}=Z_v;
    K_u_NULL{t} = KK_u_null2;
    K_v_NULL{t} = KK_v_null2;
    %% kernel density
    [f,xi] = ksdensity(Z_u(:,2),-10:.1:10);
    FU_kernel_mov(t,:)=f';
    XU_kernel_mov(t,:)=xi';
    
    [f,xi] = ksdensity(Z_v(:,2),-10:.1:10);
    FV_kernel_mov(t,:)=f';
    XV_kernel_mov(t,:)=xi';
    
end
%% save
save('pezzoNull_2Victim.mat','FV_kernel_mov','FU_kernel_mov','XU_kernel_mov',...
    'XV_kernel_mov','Z_SCORE_v','Z_SCORE_u')
%% associo nodi a z-score
calormap=turbo(length(MM));
ZscoreU = [];
ZscoreV = [];
NodiU = [];
NodiV = [];
ColorU = [];
ColorV = [];
TempiV = [];
TempiU = [];

for t = 1:length(MM)
    ZscoreU = [ZscoreU;Z_SCORE_u{t}(:,2)];
    ZscoreV = [ZscoreV;Z_SCORE_v{t}(:,2)];
    NodiU = [NodiU;Nodi_v{t}];
    NodiV = [NodiV;Nodi_u{t}];
    TempiV = [TempiV;repmat(t,length(Nodi_u{t}),1)];
    TempiU = [TempiU;repmat(t,length(Nodi_v{t}),1)];
    ColorU = [ColorU; repmat(calormap(t,:),length(Nodi_v{t}),1)];
    ColorV = [ColorV; repmat(calormap(t,:),length(Nodi_u{t}),1)];
end
SopraRappV = find(ZscoreV>2);
SottoRappV = find(ZscoreV<-2);
SopraRappU = find(ZscoreU>2);
SottoRappU = find(ZscoreU<-2);

TempiSottoU = TempiU(SottoRappU);
TempiSopraU = TempiU(SopraRappU);
TempiSottoV = TempiV(SottoRappV);
TempiSopraV = TempiV(SopraRappV);

ZscoreVsopra = ZscoreV(SopraRappV);
ZscoreUsopra = ZscoreU(SopraRappU);
ZscoreVsotto = ZscoreV(SottoRappV);
ZscoreUsotto = ZscoreU(SottoRappU);

NodiU_sotto = NodiU(SottoRappU);
NodiV_sotto = NodiV(SottoRappV);
NodiU_sopra = NodiU(SopraRappU);
NodiV_sopra = NodiV(SopraRappV);

ColorV_sopra = ColorV(SopraRappV,:);
ColorU_sopra = ColorU(SopraRappU,:);
ColorV_sotto = ColorV(SottoRappV,:);
ColorU_sotto = ColorU(SottoRappU,:);

NodiU_sottoUnici = unique(NodiU_sotto);
NodiV_sottoUnici = unique(NodiV_sotto);
NodiU_sopraUnici = unique(NodiU_sopra);
NodiV_sopraUnici = unique(NodiV_sopra);

NodiU_sottoUniciZscore = zeros(length(NodiU_sottoUnici),length(MM));
NodiV_sottoUniciZscore = zeros(length(NodiV_sottoUnici),length(MM));
NodiU_sopraUniciZscore = zeros(length(NodiU_sopraUnici),length(MM));
NodiV_sopraUniciZscore = zeros(length(NodiV_sopraUnici),length(MM));

for t = 1:length(MM)
    chi1 = find(TempiSottoU==t);
    NodiU_sottoChi =NodiU_sotto(chi1);
    ZU_sottoChi =ZscoreUsopra(chi1);
    
    for x = 1:length(NodiU_sottoUnici)
        chi = find(strcmp(NodiU_sottoUnici(x),NodiU_sottoChi));
        if isempty(chi)
            zscore=0;
        else
            zscore=abs(ZU_sottoChi(chi));
        end
        NodiU_sottoUniciZscore(x,t)=zscore;
    end
    
    chi2 = find(TempiSottoV==t);
    NodiV_sottoChi =NodiV_sotto(chi2);
    ZV_sottoChi =ZscoreVsotto(chi2);
    
    for x = 1:length(NodiV_sottoUnici)
        chi = find(strcmp(NodiV_sottoUnici(x),NodiV_sottoChi));
        if isempty(chi)
            zscore=0;
        else
            zscore=abs(ZV_sottoChi(chi));
        end
        NodiV_sottoUniciZscore(x,t)=zscore;
    end
    
    chi3 = find(TempiSopraU==t);
    NodiU_sopraChi =NodiU_sopra(chi3);
    ZU_sopraChi =ZscoreUsopra(chi3);
    
    for x = 1:length(NodiU_sopraUnici)
        chi = find(strcmp(NodiU_sopraUnici(x),NodiU_sopraChi));
        if isempty(chi)
            zscore=0;
        else
            zscore=abs(ZU_sopraChi(chi));
        end
        NodiU_sopraUniciZscore(x,t)=zscore;
    end
       
    chi4 = find(TempiSopraV==t);
    NodiV_sopraChi =NodiV_sopra(chi4);
    ZV_sopraChi =ZscoreVsopra(chi4);
    
    for x = 1:length(NodiV_sopraUnici)
        chi = find(strcmp(NodiV_sopraUnici(x),NodiV_sopraChi));
        if isempty(chi)
            zscore=0;
        else
            zscore=abs(ZV_sopraChi(chi));
        end
        NodiV_sopraUniciZscore(x,t)=zscore;
    end  
end

[DoveTopV_sopra, TopV_sopra] = sort(sum(NodiV_sopraUniciZscore,2),'descend');
TopV_sopra = TopV_sopra(1:7);
DoveTopV_sopra = DoveTopV_sopra(1:7);
NomiTopV_sopra=NodiV_sopraUnici(TopV_sopra);

[DoveTopU_sopra, TopU_sopra] = sort(sum(NodiU_sopraUniciZscore,2),'descend');
TopU_sopra = TopU_sopra(1:7);
DoveTopU_sopra = DoveTopU_sopra(1:7);
NomiTopU_sopra=NodiU_sopraUnici(TopU_sopra);

[DoveTopV_sotto, TopV_sotto] = sort(sum(NodiV_sottoUniciZscore,2),'descend');
TopV_sotto = TopV_sotto(1:7);
DoveTopV_sotto = DoveTopV_sotto(1:7);
NomiTopV_sotto=NodiV_sottoUnici(TopV_sotto);

[DoveTopU_sotto, TopU_sotto] = sort(sum(NodiU_sottoUniciZscore,2),'descend');
TopU_sotto = TopU_sotto(1:7);
DoveTopU_sotto = DoveTopU_sotto(1:7);
NomiTopU_sotto=NodiU_sottoUnici(TopU_sotto);
%% plot nodi
% figure
% subplot(2,2,1)
% wordcloud(NodiV_sopra,abs(SopraRappV),'Color',ColorV_sopra,'MaxDisplayWords',50)
% subplot(2,2,2)
% wordcloud(NodiV_sotto,abs(SottoRappV),'Color',ColorV_sotto,'MaxDisplayWords',50)
% 
% subplot(2,2,3)
% wordcloud(NodiU_sopra,abs(SopraRappU),'Color',ColorU_sopra,'MaxDisplayWords',50)
% subplot(2,2,4)
% wordcloud(NodiU_sotto,abs(SottoRappU),'Color',ColorU_sotto,'MaxDisplayWords',50)
%% plot bar nodi
figure
b=bar(NodiV_sopraUniciZscore,'Stacked','FaceColor','flat');
for k = 1:size(NodiV_sopraUniciZscore,2)
    b(k).CData = calormap(k,:);
end
axis tight
title('Under-estimated Terrorist cell Coeff')
grid on
ylabel('Abs. z-score')
legend(string(num2str([1970:1992,1994:2019]')),'Orientation','horizontal','NumColumns',10,'location','southoutside')
text(TopV_sopra,DoveTopV_sopra,NomiTopV_sopra)
set(gca,'fontsize',12,'fontweight','bold')
figure
b=bar(NodiU_sopraUniciZscore,'Stacked','FaceColor','flat');
for k = 1:size(NodiU_sopraUniciZscore,2)
    b(k).CData = calormap(k,:);
end
axis tight
title('Over-estimated Terrorist cell Coeff')
grid on
ylabel('Abs. z-score')
legend(string(num2str([1970:1992,1994:2019]')),'Orientation','horizontal','NumColumns',10,'location','southoutside')
text(TopU_sopra,DoveTopU_sopra,NomiTopU_sopra)
set(gca,'fontsize',12,'fontweight','bold')
figure
b=bar(NodiV_sottoUniciZscore,'Stacked','FaceColor','flat');
for k = 1:size(NodiV_sottoUniciZscore,2)
    b(k).CData = calormap(k,:);
end
axis tight
title('Under-estimated Target Nodes Coeff')
grid on
ylabel('Abs. z-score')
legend(string(num2str([1970:1992,1994:2019]')),'Orientation','horizontal','NumColumns',10,'location','southoutside')
text(TopV_sotto,DoveTopV_sotto,NomiTopV_sotto)
set(gca,'fontsize',12,'fontweight','bold')
figure
b=bar(NodiU_sottoUniciZscore,'Stacked','FaceColor','flat');
for k = 1:size(NodiU_sottoUniciZscore,2)
    b(k).CData = calormap(k,:);
end
axis tight
title('Over-estimated Target Nodes Coeff')
grid on
ylabel('Abs. z-score')
legend(string(num2str([1970:1992,1994:2019]')),'Orientation','horizontal','NumColumns',10,'location','southoutside')
text(TopU_sotto,DoveTopU_sotto,NomiTopU_sotto)
set(gca,'fontsize',12,'fontweight','bold')
%% plot
cmapX = 'plasma';                                                          %viridis, inferno, magma, plasma, civdis (default),                                                                        %    devon, oslo and tokyo are possible
cmap2X = 'viridis';                                                          %viridis, inferno, magma, plasma, civdis (default),                                                                        %    devon, oslo and tokyo are possible
flipCmap = true;
view = [-1.328177319587629e+02,46.874657524863665];                                                           %    default = [-38 27]
fAlpha = 0.1;                                                              %    FaceAlpha (default = 0.25)
lWidth = 1;
figure('Name','Kernels')
subplot(1,2,1)
multiTrace3D(1:length(MM),1:201,FV_kernel_mov',cmapX,view,fAlpha,lWidth,flipCmap);
axis tight
yticks(1:20:201)
yticklabels(-10:2:10)
ylabel('Z-score')
xticks(1:3:length(MM))
xticklabels(string(num2str([1970:3:1992,1994:3:2019]')))
zlabel('PDF')
title('K-2')
xtickangle(30)
ytickangle(330)
ax = gca;
ax.ZAxis.Exponent = .02;
set(gca,'fontsize',12,'fontweight','bold')
subplot(1,2,2)
multiTrace3D(1:length(MM),1:201,FU_kernel_mov',cmap2X,view,fAlpha,lWidth,flipCmap);
axis tight
yticks(1:20:201)
yticklabels(-10:2:10)
ylabel('Z-score')
xticks(1:3:length(MM))
xticklabels(string(num2str([1970:3:1992,1994:3:2019]')))
zlabel('PDF')
title('K-2')
xtickangle(30)
ytickangle(330)
ax = gca;
ax.ZAxis.Exponent = .02;
set(gca,'fontsize',12,'fontweight','bold')