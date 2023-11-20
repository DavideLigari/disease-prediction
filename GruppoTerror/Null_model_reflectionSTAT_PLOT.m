clc; clearvars; close all
%% addpath
addpath('C:\Users\Alessandro\Desktop\GruppoTerror\MAX&SAM routines')
%% load net
load Target_TerrorNetFINAL
Nodi_v = NodiTargetVictim; 
Nodi_u = NodiTerrorVictim;
MM = Adj_Victim;
%load SoluzioniAttack
load pezzoNull_2VictimDEG

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
SopraRappV = find(ZscoreV>1.645);
SottoRappV = find(ZscoreV<-1.645);
SopraRappU = find(ZscoreU>1.645);
SottoRappU = find(ZscoreU<-1.645);

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
TopV_sopra = TopV_sopra(1:15);
DoveTopV_sopra = DoveTopV_sopra(1:15);
NomiTopV_sopra=NodiV_sopraUnici(TopV_sopra);

[DoveTopU_sopra, TopU_sopra] = sort(sum(NodiU_sopraUniciZscore,2),'descend');
TopU_sopra = TopU_sopra(1:15);
DoveTopU_sopra = DoveTopU_sopra(1:15);
NomiTopU_sopra=NodiU_sopraUnici(TopU_sopra);

% [DoveTopV_sotto, TopV_sotto] = sort(sum(NodiV_sottoUniciZscore,2),'descend');
% TopV_sotto = TopV_sotto(1:10);
% DoveTopV_sotto = DoveTopV_sotto(1:10);
% NomiTopV_sotto=NodiV_sottoUnici(TopV_sotto);
% 
% [DoveTopU_sotto, TopU_sotto] = sort(sum(NodiU_sottoUniciZscore,2),'descend');
% TopU_sotto = TopU_sotto(1:10);
% DoveTopU_sotto = DoveTopU_sotto(1:10);
% NomiTopU_sotto=NodiU_sottoUnici(TopU_sotto);
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
b=bar(NodiV_sopraUniciZscore,'Stacked','FaceColor','flat','EdgeColor','none');
for k = 1:size(NodiV_sopraUniciZscore,2)
    b(k).CData = calormap(k,:);
end
axis tight
title('Under-estimated HI level-2')
grid on
ylabel('Abs. z-score')
xlabel('Terrorists')
legend(string(num2str([1970:1992,1994:2019]')),'Orientation','horizontal','NumColumns',10,'location','southoutside')
text(TopV_sopra,DoveTopV_sopra,NomiTopV_sopra,'HorizontalAlignment' ,'center')
set(gca,'fontsize',12,'fontweight','bold')

figure
b=bar(NodiU_sopraUniciZscore,'Stacked','FaceColor','flat','EdgeColor','none');
for k = 1:size(NodiU_sopraUniciZscore,2)
    b(k).CData = calormap(k,:);
end
axis tight
title('Under-estimated RI level-2')
grid on
ylabel('Abs. z-score')
xlabel('Targets')
legend(string(num2str([1970:1992,1994:2019]')),'Orientation','horizontal','NumColumns',10,'location','southoutside')
text(TopU_sopra,DoveTopU_sopra,NomiTopU_sopra,'HorizontalAlignment' ,'center')
set(gca,'fontsize',12,'fontweight','bold')

% figure
% b=bar(NodiV_sottoUniciZscore,'Stacked','FaceColor','flat','EdgeColor','none');
% for k = 1:size(NodiV_sottoUniciZscore,2)
%     b(k).CData = calormap(k,:);
% end
% axis tight
% title('Over-estimated HI level-2')
% grid on
% ylabel('Abs. z-score')
% xlabel('Terrorists')
% legend(string(num2str([1970:1992,1994:2019]')),'Orientation','horizontal','NumColumns',10,'location','southoutside')
% text(TopV_sotto,DoveTopV_sotto,NomiTopV_sotto)
% set(gca,'fontsize',12,'fontweight','bold')
% 
% figure
% b=bar(NodiU_sottoUniciZscore,'Stacked','FaceColor','flat','EdgeColor','none');
% for k = 1:size(NodiU_sottoUniciZscore,2)
%     b(k).CData = calormap(k,:);
% end
% axis tight
% title('Over-estimated RI level-2')
% grid on
% ylabel('Abs. z-score')
% xlabel('Targets')
% legend(string(num2str([1970:1992,1994:2019]')),'Orientation','horizontal','NumColumns',10,'location','southoutside')
% text(TopU_sotto,DoveTopU_sotto,NomiTopU_sotto)
% set(gca,'fontsize',12,'fontweight','bold')
%% plot
cmapX = 'plasma';                                                          %viridis, inferno, magma, plasma, civdis (default),                                                                        %    devon, oslo and tokyo are possible
cmap2X = 'viridis';                                                          %viridis, inferno, magma, plasma, civdis (default),                                                                        %    devon, oslo and tokyo are possible
flipCmap = true;
view = [-1.328177319587629e+02,28.066445409701686];
%view = [-1.328177319587629e+02,46.874657524863665];                                                           %    default = [-38 27]
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
title('HI level-2 Z-score distribution')
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
title('RI level-2 Z-score distribution')
xtickangle(30)
ytickangle(330)
ax = gca;
ax.ZAxis.Exponent = .02;
set(gca,'fontsize',12,'fontweight','bold')