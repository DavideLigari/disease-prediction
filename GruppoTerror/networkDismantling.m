clc; clearvars; close all
%% addpath
addpath('C:\Users\Alessandro\Desktop\GruppoTerror\MAX&SAM routines')
%% load net
load Target_TerrorNetFINAL
Nodi_v = NodiTargetVictim{end}; 
Nodi_u = NodiTerrorVictim{end};
MM = Adj_Victim{end};

[K_Terr_real,K_Targ_real]=hid_hous(MM,2); % hidalgo-haussmann
RI1 = K_Targ_real(:,1);
RI2 = K_Targ_real(:,2);
HI1 = K_Terr_real(:,1);
HI2 = K_Terr_real(:,2);

MediaRI2 = mean(RI2);
MediaHI2 = mean(HI2);
StdRI2 = std(RI2);
StdHI2 = std(HI2);
KurtRI2 = kurtosis(RI2);
KurtHI2 = kurtosis(HI2);
%% policy prevention
x = 1:100;
aa = [1:10:200];
Smazzo = zeros(size(aa,2)/2,length(x));
Quanto = linspace(1,100,length(aa));
rgb = vals2colormap(1:length(aa), 'turbo');

for zz = 1:length(aa)
    Smazzo(zz,:)= sigmoid(x,length(x)/2,1/aa(zz));
end
figure
for k = 1:size(Smazzo,1)
    plot(x,Smazzo(k,:),'Color',rgb(k,:),'linewidth',2)
    hold on
end
ylabel('\alpha')
lg = legend(string(aa),'NumColumns',2,'location','bestoutside');
title(lg,'Sigmoid coefficients S')
set(gca,'fontsize',12,'fontweight','bold')
xlabel('Num. of Attacks Ranking (link weight)')
axis tight
grid on
%% container
MediaRI2_P = zeros(length(aa),length(Quanto));
MediaHI2_P =zeros(length(aa),length(Quanto));
StdRI2_P = zeros(length(aa),length(Quanto));
StdHI2_P = zeros(length(aa),length(Quanto));
KurtRI2_P = zeros(length(aa),length(Quanto));
KurtHI2_P = zeros(length(aa),length(Quanto));
%% network dismantling
for z = 1:length(aa)
    for h = 1:length(Quanto)
        I = find(MM>0);
        Pesi = MM(I);
        [PesiSort, Isort]=sort(Pesi);
        x = 1:length(I);
        alpha = sigmoid(x,length(x)/2,1/aa(z));
        alpha = alpha/sum(alpha);
        PesiNew = PesiSort-PesiSort*Quanto(h).*(alpha');
        MM_new = zeros(size(MM));
        MM_new(I(Isort))=PesiNew;
        
        [K_Terr_real,K_Targ_real]=hid_hous(MM_new,2); % hidalgo-haussmann
        
        RI1_P = K_Targ_real(:,1);
        RI2_P = K_Targ_real(:,2);
        HI1_P = K_Terr_real(:,1);
        HI2_P = K_Terr_real(:,2);

        MediaRI2_P(z,h) = mean(RI2_P);
        MediaHI2_P(z,h) = mean(HI2_P);
        StdRI2_P(z,h) = std(RI2_P);
        StdHI2_P(z,h) = std(HI2_P);
        KurtRI2_P(z,h) = kurtosis(RI2_P);
        KurtHI2_P(z,h) = kurtosis(HI2_P);
        
    end
end
%% plot
figure
subplot(2,2,1)
im = imagesc(MediaHI2_P,'Interpolation','bilinear');
im.AlphaData = .7;
axis square
hold on 
contour(MediaHI2_P,5,'g--','linewidth',2)
colormap('hot')
c = colorbar;
c.Label.String = 'Mean HI Level-2';
yticks(1:2:size(MediaHI2_P,1))
yticklabels(aa(1:2:end))
ylabel('Sigmoid coefficients')
xticks(1:2:size(MediaHI2_P,2))
xticklabels(round(Quanto(1:2:end)))
xlabel('Attack decrease [%]')
title('Mean HI Level-2: ',num2str(MediaHI2))
set(gca,'fontsize',12,'fontweight','bold')

subplot(2,2,2)
im = imagesc(StdHI2_P,'Interpolation','bilinear');
im.AlphaData = .7;
axis square
hold on 
contour(StdHI2_P,5,'g--','linewidth',2)
colormap('hot')
c = colorbar;
c.Label.String = 'Std HI Level-2';
yticks(1:2:size(StdHI2_P,1))
yticklabels(aa(1:2:end))
ylabel('Sigmoid coefficients')
xticks(1:2:size(StdHI2_P,2))
xticklabels(round(Quanto(1:2:end)))
xlabel('Attack decrease [%]')
title('Std HI Level-2: ',num2str(StdHI2))
set(gca,'fontsize',12,'fontweight','bold')

% subplot(1,3,3)
% im = imagesc(KurtHI2_P,'Interpolation','bilinear');
% im.AlphaData = .7;
% axis square
% hold on 
% contour(KurtHI2_P,5,'g--','linewidth',2)
% colormap('hot')
% c = colorbar;
% c.Label.String = 'Kurtosis HI Level-2';
% yticks(1:2:size(KurtHI2_P,1))
% yticklabels(aa(1:2:end))
% ylabel('Sigmoid coefficients')
% xticks(1:2:size(KurtHI2_P,2))
% xticklabels(round(Quanto(1:2:end)))
% xlabel('Attack decrease [%]')
% title('Kurtosis HI Level-2: ',num2str(KurtHI2))
% set(gca,'fontsize',12,'fontweight','bold')
% 

%% RI
%figure
subplot(2,2,3)
im = imagesc(MediaRI2_P,'Interpolation','bilinear');
im.AlphaData = .7;
axis square
hold on 
contour(MediaRI2_P,5,'g--','linewidth',2)
colormap('hot')
c = colorbar;
c.Label.String = 'Mean RI Level-2';
yticks(1:2:size(KurtRI2_P,1))
yticklabels(aa(1:2:end))
ylabel('Sigmoid coefficients')
xticks(1:2:size(KurtRI2_P,2))
xticklabels(round(Quanto(1:2:end)))
xlabel('Attack decrease [%]')
title('Mean RI Level-2: ',num2str(MediaRI2))
set(gca,'fontsize',12,'fontweight','bold')

subplot(2,2,4)
im = imagesc(StdRI2_P,'Interpolation','bilinear');
im.AlphaData = .7;
axis square
hold on 
contour(StdRI2_P,5,'g--','linewidth',2)
colormap('hot')
c = colorbar;
c.Label.String = 'Std RI Level-2';
yticks(1:2:size(KurtRI2_P,1))
yticklabels(aa(1:2:end))
ylabel('Sigmoid coefficients')
xticks(1:2:size(KurtRI2_P,2))
xticklabels(round(Quanto(1:2:end)))
xlabel('Attack decrease [%]')
title('Std RI Level-2: ',num2str(StdRI2))
set(gca,'fontsize',12,'fontweight','bold')

% subplot(1,3,3)
% im = imagesc(KurtRI2_P,'Interpolation','bilinear');
% im.AlphaData = .7;
% axis square
% hold on 
% contour(KurtRI2_P,5,'g--','linewidth',2)
% colormap('hot')
% c = colorbar;
% c.Label.String = 'Kurtosis RI Level-2';
% yticks(1:2:size(KurtRI2_P,1))
% yticklabels(aa(1:2:end))
% ylabel('Sigmoid coefficients')
% xticks(1:2:size(KurtRI2_P,2))
% xticklabels(round(Quanto(1:2:end)))
% xlabel('Attack decrease [%]')
% title('Kurtosis RI Level-2: ',num2str(KurtRI2))
% set(gca,'fontsize',12,'fontweight','bold')
