clc; clearvars; close all;
%% load data
load TerrorData
load TerrorDataPT2
load TerrorDataPT3
load MappaColo2
%% split dataset
Anni = table2array(TerrorData(2:end,1));
Target = table2array(TerrorData(2:end,6));
Terror = string(table2array(TerrorData(2:end,9)));
Successo = table2array(TerrorData(2:end,3));
Nazionalita = string(table2array(TerrorData(2:end,8)));
Attack_type = string(table2array(TerrorData(2:end,5)));
Attack_type2 = string(table2array(TerrorDataPT2(2:end,1)));
Attack_type2(ismissing(Attack_type2))="";
Morti = table2array(TerrorDataPT2(2:end,2));
Morti(isnan(Morti))=0;
Attack_typeFin =  strcat(Attack_type," ",Attack_type2);
Lat = table2array(TerrorDataTP3(2:end,2));
Lon = table2array(TerrorDataTP3(2:end,3));
%% erase unknown
tolgoterror = find(strcmp(Terror,'Unknown')==1);
Anni(tolgoterror)=[];
Target(tolgoterror)=[];
Terror(tolgoterror)=[];
Successo(tolgoterror)=[];
Nazionalita(tolgoterror)=[];
Attack_typeFin(tolgoterror)=[];
Morti(tolgoterror)=[];
Lat(tolgoterror)=[];
Lon(tolgoterror)=[];

tolgotarget = find(strcmp(Target,'')==1);
Anni(tolgotarget)=[];
Target(tolgotarget)=[];
Terror(tolgotarget)=[];
Successo(tolgotarget)=[];
Nazionalita(tolgotarget)=[];
Attack_typeFin(tolgotarget)=[];
Morti(tolgotarget)=[];
Lat(tolgotarget)=[];
Lon(tolgotarget)=[];

tolgoinsuccesso = find(Successo==0);
Anni(tolgoinsuccesso)=[];
Target(tolgoinsuccesso)=[];
Terror(tolgoinsuccesso)=[];
Successo(tolgoinsuccesso)=[];
Nazionalita(tolgoinsuccesso)=[];
Attack_typeFin(tolgoinsuccesso)=[];
Morti(tolgoinsuccesso)=[];
Lat(tolgoinsuccesso)=[];
Lon(tolgoinsuccesso)=[];

tolgomultinat = find(strcmp(Nazionalita,'Multinational')==1);
Anni(tolgomultinat)=[];
Target(tolgomultinat)=[];
Terror(tolgomultinat)=[];
Successo(tolgomultinat)=[];
Nazionalita(tolgomultinat)=[];
Attack_typeFin(tolgomultinat)=[];
Morti(tolgomultinat)=[];
Lat(tolgomultinat)=[];
Lon(tolgomultinat)=[];

%% years
Anni_unici = unique(Anni);
%% containers
FU_kernel_mov = zeros(length(Anni_unici),101);
XU_kernel_mov = zeros(length(Anni_unici),101);

%% main
for t = 1:length(Anni_unici)
    disp(Anni_unici(t));
    % prendo eventi dell'anno
    estraggo_anno = find(Anni==Anni_unici(t));
    MortiAnno = Morti(estraggo_anno);
     %% kernel density
     MortiAnno(MortiAnno==0)=[];
    [f,xi] = ksdensity(MortiAnno,1:101);
    FU_kernel_mov(t,:)=f';
    XU_kernel_mov(t,:)=xi';
   
end
%% plot
cmapX = 'plasma';                                                          %viridis, inferno, magma, plasma, civdis (default),                                                                        %    devon, oslo and tokyo are possible
cmap2X = 'viridis';                                                          %viridis, inferno, magma, plasma, civdis (default),                                                                        %    devon, oslo and tokyo are possible
flipCmap = true;
view = [-1.328177319587629e+02,46.874657524863665];                                                           %    default = [-38 27]
fAlpha = 0.1;                                                              %    FaceAlpha (default = 0.25)
lWidth = 1;

multiTrace3D(1:length(Anni_unici),1:101,FU_kernel_mov',cmap2X,view,fAlpha,lWidth,flipCmap);
axis tight
yticks(1:10:101)
yticklabels(1:10:101)
ylabel('Deaths')
xticks(1:3:length(Anni_unici))
xticklabels(string(num2str([1970:3:1992,1994:3:2019]')))
zlabel('PDF')
title('Deaths distribution')
xtickangle(30)
ytickangle(330)
ax = gca;
ax.ZAxis.Exponent = .02;
set(gca,'fontsize',12,'fontweight','bold')

%% morti distribution
[counts, x] = hist(Morti, 10.^(0:0.1:3)); %Compute the density of degree intervals
figure
subplot(2,1,1)
[power] = logfit(x,counts,'loglog');
xlabel('Deaths');
ylabel('P(Deaths)');
title('Deaths distribution')
axis square
grid on

Note = {'Rwandan genocide';'9-11 Attacks';'Camp Speicher massacre'};
set(gca,'fontsize',12,'fontweight','bold')
subplot(2,1,2)
plot(Morti)
text([33387,40696,63582],[1180,1385,1570],Note)
axis tight
grid on
ylabel('Nunber of Deaths');
title('Deaths per attack')
xticks(1:5900:length(Anni))
xticklabels(Anni(1:5900:end))
xtickangle(30)
set(gca,'fontsize',12,'fontweight','bold')