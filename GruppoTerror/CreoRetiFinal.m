clc; clearvars; close all;
%% load data
load TerrorData
load TerrorDataPT2
load TerrorDataPT3
load TerrorDataPT4
load MappaColo2
%% split dataset
Anni = table2array(TerrorData(2:end,1));
Target = string(table2array(TerrorData(2:end,6)));
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

tolgotarget = find(strcmp(Target,'Unknown')==1);
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

tolgolat = isnan(Lat);
Anni(tolgolat)=[];
Target(tolgolat)=[];
Terror(tolgolat)=[];
Successo(tolgolat)=[];
Nazionalita(tolgolat)=[];
Attack_typeFin(tolgolat)=[];
Morti(tolgolat)=[];
Lat(tolgolat)=[];
Lon(tolgolat)=[];

tolgolon = isnan(Lon);
Anni(tolgolon)=[];
Target(tolgolon)=[];
Terror(tolgolon)=[];
Successo(tolgolon)=[];
Nazionalita(tolgolon)=[];
Attack_typeFin(tolgolon)=[];
Morti(tolgolon)=[];
Lat(tolgolon)=[];
Lon(tolgolon)=[];

%% associate continent to lat long
addpath('C:\Users\Alessandro\Desktop\GruppoTerror\mygeodata')
S = shaperead('unnamed.gdb-polygon');
Contienti = string({S.CONTINENT});
load Continenti_ind
TFin = str2double(TFin);
% TFin(isnan(TFin))=[];
% boundlat = {S.Y};
% boundlon = {S.X};
% TFin = strings(length(Anni),1);
% for i = 1:length(Contienti)
%     Contienti(i)
%     Chi = inpolygon(Lon,Lat,boundlon{i},boundlat{i});
%     TFin(Chi)=i;
% end

%% container
Anni_unici = unique(Anni);
Adj_Attack = cell(length(Anni_unici),1);
Adj_Victim = cell(length(Anni_unici),1);

NodiTerrorAttack = cell(length(Anni_unici),1);
NodiTargetAttack = cell(length(Anni_unici),1);

NodiTerrorVictim = cell(length(Anni_unici),1);
NodiTargetVictim = cell(length(Anni_unici),1);

Num_Continents = zeros(length(Anni_unici),length(Contienti));
Num_Terror=zeros(length(Anni_unici),1);
Num_Target=zeros(length(Anni_unici),1);
Num_TerrorV=zeros(length(Anni_unici),1);
Num_TargetV=zeros(length(Anni_unici),1);

Num_Victim = zeros(length(Anni_unici),1);
Num_ContinentsVictim = zeros(length(Anni_unici),length(Contienti));
%% main
for t = 1:length(Anni_unici)
    disp(Anni_unici(t));
    % prendo eventi dell'anno
    estraggo_anno = find(Anni==Anni_unici(t));
    TargetAnno = Target(estraggo_anno);
    TerrorAnno = Terror(estraggo_anno);
    NationAnno = Nazionalita(estraggo_anno);
    MortiAnno = Morti(estraggo_anno);
    TargetNationAnno = join([TargetAnno,NationAnno]," ");
   
    Cont_Anno = TFin(estraggo_anno);
    for zz = 1:length(Contienti)
        Num_Continents(t,zz)=length(find(Cont_Anno==zz));
    end
       
    % creo nodi reti
    Target_node = unique(TargetNationAnno);
    Terror_node = unique(TerrorAnno);
   
    Target_nodeV = unique(TargetNationAnno);
    Terror_nodeV = unique(TerrorAnno);
    
    Adj_anno = zeros(length(Target_node),length(Terror_node));
    Adj_anno_Victim = zeros(length(Target_node),length(Terror_node));
  
    %main loop
    for x = 1:length(Terror_node)
        % per ogni terrorist
        terror = find(strcmp(TerrorAnno,Terror_node(x))==1);
        % prendo le sue vittime
        TargetAnno_restricted = TargetNationAnno(terror);
        MortiAnno_restricted = MortiAnno(terror);
        for z = 1:length(TargetAnno_restricted) 
            % vedo dove sono le vittime in Target_node
            victim = strcmp(Target_node,TargetAnno_restricted(z));
            % piazzo link
            Adj_anno_Victim(victim,x)=Adj_anno_Victim(victim,x)+MortiAnno_restricted(z);
            Adj_anno(victim,x)=Adj_anno(victim,x)+1;
        end          
    end
    % tolgo zeros links
    tol_terr = find(sum(Adj_anno)==0);
    tol_targ =find(sum(Adj_anno,2)==0);   
         
    Adj_anno(tol_targ,:)=[];
    Adj_anno(:,tol_terr)=[];
    
    Terror_node(tol_terr)=[];
    Target_node(tol_targ)=[];
    
    tol_terrV = find(sum(Adj_anno_Victim)==0);
    tol_targV =find(sum(Adj_anno_Victim,2)==0);   
    
    Adj_anno_Victim(tol_targV,:)=[];
    Adj_anno_Victim(:,tol_terrV)=[];
    
    Terror_nodeV(tol_terrV)=[];
    Target_nodeV(tol_targV)=[];

    % colleziono
    NodiTerrorAttack{t}=Terror_node;
    NodiTargetAttack{t}=Target_node;
    NodiTerrorVictim{t}=Terror_nodeV;
    NodiTargetVictim{t}=Target_nodeV;
    
    Num_Terror(t)=length(Terror_node);
    Num_Target(t)=length(Target_node);
    Num_TerrorV(t)=length(Terror_nodeV);
    Num_TargetV(t)=length(Target_nodeV);

    
    % colleziono
    Adj_Attack{t}=Adj_anno;
    Adj_Victim{t}=Adj_anno_Victim;
  
end

%% save
save('Target_TerrorNetFINAL.mat','Anni_unici','Adj_Attack','Adj_Victim','NodiTerrorAttack','NodiTargetAttack','NodiTerrorVictim','NodiTargetVictim');

%% associato nation continent
out1=(ismember(Anni,1970:1990));
out2=(ismember(Anni,1991:2019));
figure
subplot(3,2,1:4)
geodensityplot(Lat,Lon,'FaceColor','interp','Radius',500000)
colormap hot
title('Attacks Locations 1970-2019')
subplot(3,2,5)
geodensityplot(Lat(out1),Lon(out1),'FaceColor','interp','Radius',500000)
colormap hot
title('Attacks Locations 1970-1990')
subplot(3,2,6)
geodensityplot(Lat(out2),Lon(out2),'FaceColor','interp','Radius',500000)
colormap hot
title('Attack Locations 1991-2019')
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
%% attack plot
MappaColoCont = MappaColo(2:40:end,:);
figure
b=bar(Num_Continents,'Stacked','FaceColor','flat');
for k = 1:size(Num_Continents,2)
    b(k).CData = MappaColoCont(k,:);
end
xticks(1:2:length(Anni_unici))
xticklabels(Anni_unici(1:2:end))
xtickangle(30)
axis tight
grid on
title('Number of attacks per continent')
ylabel('Number of attacks')
legend(Contienti)
set(gca,'fontsize',12,'fontweight','bold')
%% node plot
figure
% subplot(2,4,1)
% wordcloud(categorical(NodiTerrorAttack{23}),sum(Adj_Attack{23}),'MaxDisplayWords',10,'HighlightColor','k','color',[0 0 0])
% subplot(2,4,2)
% wordcloud(categorical(NodiTargetAttack{23}),sum(Adj_Attack{23},2),'MaxDisplayWords',10,'HighlightColor','k','color',[0 0 0])
% 
% subplot(2,4,3)
% wordcloud(categorical(NodiTerrorAttack{45}),sum(Adj_Attack{45}),'MaxDisplayWords',10,'HighlightColor','k','color',[0 0 0])
% subplot(2,4,4)
% wordcloud(categorical(NodiTargetAttack{45}),sum(Adj_Attack{45},2),'MaxDisplayWords',10,'HighlightColor','k','color',[0 0 0])

%subplot(2,4,5:8)
yyaxis right
plot(Num_Terror,'ko-','linewidth',2)
xticks(1:2:length(Anni_unici))
xticklabels(Anni_unici(1:2:end))
xtickangle(30)
axis tight
grid on
ylabel('Num. of Terrorists')
yyaxis left
plot(Num_Target,'^-','linewidth',2,'color',[0.7 0.7 0.7])
xticks(1:2:length(Anni_unici))
xticklabels(Anni_unici(1:2:end))
xtickangle(30)
axis tight
grid on
ylabel('Num. of Targets')
ax = gca;
ax.YAxis(1).Color = 'k';
ax.YAxis(2).Color = 'k';
set(gca,'fontsize',12,'fontweight','bold')


figure
% subplot(2,4,1)
% wordcloud(categorical(NodiTerrorVictim{23}),sum(Adj_Victim{23}),'MaxDisplayWords',10,'HighlightColor','k','color',[0 0 0])
% subplot(2,4,2)
% wordcloud(categorical(NodiTargetVictim{23}),sum(Adj_Victim{23},2),'MaxDisplayWords',10,'HighlightColor','k','color',[0 0 0])
% 
% subplot(2,4,3)
% wordcloud(categorical(NodiTerrorVictim{45}),sum(Adj_Victim{45}),'MaxDisplayWords',10,'HighlightColor','k','color',[0 0 0])
% subplot(2,4,4)
% wordcloud(categorical(NodiTargetVictim{45}),sum(Adj_Victim{45},2),'MaxDisplayWords',10,'HighlightColor','k','color',[0 0 0])

%subplot(2,4,5:8)
yyaxis right
plot(tsmovavg(Num_TerrorV','s',5),'ko-','linewidth',2)
xticks(1:2:length(Anni_unici))
xticklabels(Anni_unici(1:2:end))
xtickangle(30)
axis tight
grid on
ylabel('Num. of Terrorists')
yyaxis left
plot(tsmovavg(Num_TargetV','s',5),'^-','linewidth',2,'color',[0.7 0.7 0.7])
xticks(1:2:length(Anni_unici))
xticklabels(Anni_unici(1:2:end))
xtickangle(30)
axis tight
grid on
ylabel('Num. of Targets')
ax = gca;
ax.YAxis(1).Color = 'k';
ax.YAxis(2).Color = 'k';
set(gca,'fontsize',12,'fontweight','bold')

