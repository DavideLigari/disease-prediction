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

% tolgomultinat = find(strcmp(Nazionalita,'Multinational')==1);
% Anni(tolgomultinat)=[];
% Target(tolgomultinat)=[];
% Terror(tolgomultinat)=[];
% Successo(tolgomultinat)=[];
% Nazionalita(tolgomultinat)=[];
% Attack_typeFin(tolgomultinat)=[];
% Morti(tolgomultinat)=[];
% Lat(tolgomultinat)=[];
% Lon(tolgomultinat)=[];
%% associate continent to lat long
addpath('C:\Users\Alessandro\Desktop\GruppoTerror\mygeodata')
S = shaperead('unnamed.gdb-polygon');
Contienti = string({S.CONTINENT});
Contienti(9)="Unknown";
load Continenti_ind
TFin = str2double(TFin);
TFin(isnan(TFin))=9;
% boundlat = {S.Y};
% boundlon = {S.X};
% TFin = strings(length(Anni),1);
% for i = 1:length(Contienti)
%     Contienti(i)
%     Chi = inpolygon(Lon,Lat,boundlon{i},boundlat{i});
%     TFin(Chi)=i;
% end

%% associato nation continent
out1=(ismember(Anni,1970:1990));
out2=(ismember(Anni,1991:2019));
figure
subplot(3,2,1:4)
geodensityplot(Lat,Lon,'FaceColor','interp','Radius',500000)
colormap hot
title('Attack Locations 1970-2019')
subplot(3,2,5)
geodensityplot(Lat(out1),Lon(out1),'FaceColor','interp','Radius',500000)
colormap hot
title('Attack Locations 1970-1990')
subplot(3,2,6)
geodensityplot(Lat(out2),Lon(out2),'FaceColor','interp','Radius',500000)
colormap hot
title('Attack Locations 1991-2019')

%% morti distribution
[counts, x] = hist(Morti, 10.^(0:0.1:3)); %Compute the density of degree intervals
power = logfit(x,counts,'loglog');
xlabel('Deaths');
ylabel('P(Deaths distribution)');
title('Deaths distribution')
axis tight
grid on

figure
plot(Morti)
axis tight
grid on
ylabel('Nuber of Deaths');
title('Deaths per attacck')
xticks(1:2000:length(Anni))
xticklabels(Anni(1:2000:end))
xtickangle(30)
%% word cloud
figure
wordcloud(categorical(Terror),'HighlightColor',[0 0.4470 0.7410],...
    'Shape','rectangle','LayoutNum',2)
title('Terrorist cells 1970-2019')

figure
wordcloud(categorical(Nazionalita),'HighlightColor',[0.8500 0.3250 0.0980],'Shape','rectangle')
title('Target Nationality 1970-2019')

figure
wordcloud(categorical(Target),'HighlightColor',[0.4660 0.6740 0.1880],'Shape','rectangle')
title('Target Type 1970-2019')

figure
wordcloud(categorical(Attack_typeFin),'HighlightColor',[0.9290 0.6940 0.1250],'Shape','rectangle')
title('Attack Type 1970-2019')

%% create net
Anni_unici = unique(Anni);
Adj_container = cell(length(Anni_unici),1);
Adj_container_Nationality = cell(length(Anni_unici),1);
Adj_container_Attack = cell(length(Anni_unici),1);

NodiTerror = cell(length(Anni_unici),1);
NodiTarget = cell(length(Anni_unici),1);
NodiNation = cell(length(Anni_unici),1);
NodiAttack = cell(length(Anni_unici),1);

Num_Links = zeros(length(Anni_unici),1);
Num_Continents = zeros(length(Anni_unici),length(Contienti));

Num_Terror = zeros(length(Anni_unici),1);
Num_Target = zeros(length(Anni_unici),1);
Num_Nation = zeros(length(Anni_unici),1);
Num_Morti = zeros(length(Anni_unici),1);

for t = 1:length(Anni_unici)
    disp(Anni_unici(t));
    % prendo eventi dell'anno
    estraggo_anno = find(Anni==Anni_unici(t));
    TargetAnno = Target(estraggo_anno);
    TerrorAnno = Terror(estraggo_anno);
    NationAnno = Nazionalita(estraggo_anno);
    AttackAnno = Attack_typeFin(estraggo_anno);
    MortiAnno = Morti(estraggo_anno);
   
    Cont_Anno = TFin(estraggo_anno);
    for zz = 1:length(Contienti)
        Num_Continents(t,zz)=length(find(Cont_Anno==zz));
    end
       
    % creo nodi reti
    Target_node = unique(TargetAnno);
    Terror_node = unique(TerrorAnno);
    Nation_node = unique(NationAnno);
    Attack_node = unique(AttackAnno);
    
  
    
    Adj_anno = zeros(length(Target_node),length(Terror_node));
    Adj_anno_Nation = zeros(length(Nation_node),length(Terror_node));
    Adj_anno_Attack = zeros(length(Attack_node),length(Terror_node));
    
    %main loop
    for x = 1:length(Terror_node)
        % per ogni terrorist
        terror = find(strcmp(TerrorAnno,Terror_node(x))==1);
        % prendo le sue vittime
        TargetAnno_restricted = TargetAnno(terror);
        MortiAnno_restricted = MortiAnno(terror);
        for z = 1:length(TargetAnno_restricted) 
            % vedo dove sono le vittime in Target_node
            victim = strcmp(Target_node,TargetAnno_restricted(z));
            % piazzo link
            %Adj_anno(victim,x)=Adj_anno(victim,x)+MortiAnno_restricted(z);
            Adj_anno(victim,x)=Adj_anno(victim,x)+1;
        end       
        % prendo le nazionalità
        NationalityAnno_restricted = NationAnno(terror);
        for z = 1:length(NationalityAnno_restricted) 
            % vedo dove sono le vittime in Target_node
            victimN = strcmp(Nation_node,NationalityAnno_restricted(z));
            % piazzo link
            %Adj_anno_Nation(victimN,x)=Adj_anno_Nation(victimN,x)+MortiAnno_restricted(z);
            Adj_anno_Nation(victimN,x)=Adj_anno_Nation(victimN,x)+1;
        end
        % prendo tipi attacco
        AttackAnno_restricted = AttackAnno(terror);
        for z = 1:length(AttackAnno_restricted) 
            % vedo dove sono le vittime in Target_node
            victimA = strcmp(Attack_node,AttackAnno_restricted(z));
            % piazzo link
            %Adj_anno_Attack(victimA,x)=Adj_anno_Attack(victimA,x)+MortiAnno_restricted(z);
            Adj_anno_Attack(victimA,x)=Adj_anno_Attack(victimA,x)+1;
        end      
    end
    % tolgo zeros links
    tol_terr = find(sum(Adj_anno)==0);
    tol_targ =find(sum(Adj_anno,2)==0);   
    tol_nat = find(sum(Adj_anno_Nation,2)==0);
    tol_att = find(sum(Adj_anno_Attack,2)==0);
     
    Adj_anno(tol_targ,:)=[];
    Adj_anno(:,tol_terr)=[];
    
    Adj_anno_Nation(tol_nat,:)=[];
    Adj_anno_Nation(:,tol_terr)=[];
    
    Adj_anno_Attack(tol_att,:)=[];
    Adj_anno_Attack(:,tol_terr)=[];
    
    Terror_node(tol_terr)=[];
    Target_node(tol_targ)=[];
    Nation_node(tol_nat)=[];
    Attack_node(tol_att)=[];
    % colleziono
    NodiTerror{t}=Terror_node;
    NodiTarget{t}=Target_node;
    NodiNation{t}=Nation_node;
    NodiAttack{t}=Attack_node;
    
    Num_Terror(t)=length(Terror_node);
    Num_Target(t)=length(Target_node);
    Num_Nation(t)=length(Nation_node);
    
    Num_Morti(t)=sum(MortiAnno);
    Num_Links(t)=length(estraggo_anno);
    
    % colleziono
    Adj_container{t}=Adj_anno;
    Adj_container_Nationality{t}=Adj_anno_Nation;
    Adj_container_Attack{t}=Adj_anno_Attack;
end
%% plot
MappaColoCont = MappaColo(2:30:end,:);
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

figure
yyaxis right
plot(Num_Links,'linewidth',2)
xticks(1:2:length(Anni_unici))
xticklabels(Anni_unici(1:2:end))
xtickangle(30)
axis tight
grid on
ylabel('Number of attacks')
yyaxis left
plot(Num_Morti,'linewidth',2)
xticks(1:2:length(Anni_unici))
xticklabels(Anni_unici(1:2:end))
xtickangle(30)
axis tight
grid on
ylabel('Number of deaths')
legend('Attacks','Deaths')
ax = gca;
ax.YAxis(1).Color = 'k';
ax.YAxis(2).Color = 'k';

figure
plot(Num_Nation,'linewidth',2)
xticks(1:2:length(Anni_unici))
xticklabels(Anni_unici(1:2:end))
xtickangle(30)
axis tight
grid on
title('Number of Nationalities of Targets')

figure
yyaxis right
plot(Num_Terror,'linewidth',2)
xticks(1:2:length(Anni_unici))
xticklabels(Anni_unici(1:2:end))
xtickangle(30)
axis tight
grid on
ylabel('Number of Terrorist cells')
yyaxis left
plot(Num_Target,'linewidth',2)
xticks(1:2:length(Anni_unici))
xticklabels(Anni_unici(1:2:end))
xtickangle(30)
axis tight
grid on
ylabel('Number of Targets')
%% save
save('Target_Terror.mat','Adj_container','Adj_container_Nationality','Adj_container_Attack',...
    'NodiTerror','NodiTarget','NodiNation','NodiAttack');