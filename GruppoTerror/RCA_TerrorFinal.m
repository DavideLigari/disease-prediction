clc; clearvars; close all;
%% load colormap
load MappaColo2
load('Target_TerrorNetFINAL')
%% option
thresh = 0:.1:100; % threshold per RCA
Adj = Adj_Attack;
Adj2 = Adj_Victim;
%% relative comparative advantage
[BigElem, MM_Attack] = Rel_Comp_Adv(Adj,thresh);

RCA_plot1 = zeros(length(Adj),size(thresh,2));
for t = 1:length(Adj)
    M = Adj{t};
    ee = size(M,1)*size(M,2);
    RCA_plot1(t,:)=BigElem{t}./ee;  
end

[BigElem, MM_Victim] = Rel_Comp_Adv(Adj2,thresh);

RCA_plot2 = zeros(length(Adj),size(thresh,2));
for t = 1:length(Adj)
    M = Adj2{t};
    ee = size(M,1)*size(M,2);
    RCA_plot2(t,:)=BigElem{t}./ee;  
end
%% plot
anniLeg = Anni_unici;
anniLeg = [anniLeg;"Thresholds"];
yy = unique(round(logspace(0,3,20)));
tr_1 = find(thresh==1);
ColoriAnno = MappaColo(1:7:end,:);


figure()
for j = 1:size(RCA_plot1,1)
    semilogx(RCA_plot1(j,2:1001)','linewidth',2,'Color',ColoriAnno(j,:));
    hold on
end
aus = [0:0.0001:max(max(RCA_plot1(1:end,2:1001)))];
line (tr_1*ones(1,length(aus)) ,aus,...
    'Color','black','LineStyle','--')
ll=legend(anniLeg,'NumColumns',3);
title(ll,'Years and Threshold')
xticks(yy)
xticklabels(round(thresh(yy),1))
hold on
xlabel('Thresholds')
ylabel('Density')
grid on
axis tight
title('Attack Network Density as a function of the RCA threshold')
set(gca,'fontsize',12,'fontweight','bold')

figure()
for j = 1:size(RCA_plot2,1)
    semilogx(RCA_plot2(j,2:1001)','linewidth',2,'Color',ColoriAnno(j,:));
    hold on
end
aus = [0:0.0001:max(max(RCA_plot2(1:end,2:1001)))];
line (tr_1*ones(1,length(aus)) ,aus,...
    'Color','black','LineStyle','--')
ll=legend(anniLeg,'NumColumns',3);
title(ll,'Years and Threshold')
xticks(yy)
xticklabels(round(thresh(yy),1))
hold on
xlabel('Thresholds')
ylabel('Density')
grid on
axis tight
title('Victim Network Density as a function of the RCA threshold')
set(gca,'fontsize',12,'fontweight','bold')
%% save
% save('RCA_Final.mat','MM_Attack','MM_Victim')