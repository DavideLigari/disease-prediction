clc; clearvars; close all
%% load network
 load Target_TerrorNetFINAL
Nodi_v = NodiTargetAttack; 
Nodi_u = NodiTerrorAttack;
MM = Adj_Attack;
%% container
LinkDM = zeros(length(MM),1);
LinkTot = zeros(length(MM),1);
TranvTerror = zeros(length(MM),1);
TranvTarget = zeros(length(MM),1);
Trasversal_Target = cell(length(MM),1);
Trasversal_Terror = cell(length(MM),1);
%% final net
[K_Terr_real,K_Targ_real]=hid_hous(MM{end},2); % hidalgo-haussmann
RI1 = K_Targ_real(:,1);
RI2 = K_Targ_real(:,2);
HI1 = K_Terr_real(:,1);
HI2 = K_Terr_real(:,2);

%% net preproccess
for k = 1:length(MM)
    Adj = MM{k};
    N1 = Nodi_v{k};
    N2 = Nodi_u{k};
    
    [p,q,r,s,cc,rr] = dmperm(Adj);
    C_anni = Adj(p,q);
    Blocco2_anni =  C_anni(rr(1):rr(2)-1,cc(4):cc(4+1)-1);
    LinkDM(k)=sum(sum(Blocco2_anni));
    LinkTot(k)=sum(sum((C_anni)));
    TranvTerror(k) = length(find(sum(Blocco2_anni,2)>0))./length(find(sum(Adj,2)>0));
    TranvTarget(k) = length(find(sum(Blocco2_anni,1)>0))./length(find(sum(Adj,1)>0));
    % trasversal nodes
    N_b = N1(p);
    N_s = N2(q);
    Trasversal_Terror{k} = N_s(cc(3):cc(4+1)-1);
    Trasversal_Target{k} = N_b(rr(1):rr(2+1)-1);    
end
%% target transversal
[TransTarg_fin,ia,ib] = intersect(Nodi_v{end},Trasversal_Target{end});
[TransTerr_fin,ia2,ib2] = intersect(Nodi_u{end},Trasversal_Terror{end});
adj = MM{end};
adj(ib,ib2)=0;

[K_Terr_real,K_Targ_real]=hid_hous(adj,2); % hidalgo-haussmann
RI1_dm = K_Targ_real(:,1);
RI2_dm = K_Targ_real(:,2);
HI1_dm = K_Terr_real(:,1);
HI2_dm = K_Terr_real(:,2);

%% figure
figure
subplot(2,1,1)
plot((LinkDM./LinkTot)*100,'bd-','linewidth',2)
grid on
axis tight
title('Transversal Links [%]')
set(gca,'fontsize',12,'fontweight','bold')
xticks(1:2:length(Anni_unici))
xticklabels(Anni_unici(1:2:end))
xtickangle(30)
subplot(2,1,2)
yyaxis left
plot(TranvTerror*100,'ko-','linewidth',2)
axis tight
grid on
ylabel('Terrorists')
yyaxis right
plot(TranvTarget*100,'^-','linewidth',2,'color',[0.7 0.7 0.7])
grid on
axis tight
title('Transversal Nodes [%]')
xticks(1:2:length(Anni_unici))
xticklabels(Anni_unici(1:2:end))
xtickangle(30)
axis tight
grid on
ylabel('Targets')
ax = gca;
ax.YAxis(1).Color = 'k';
ax.YAxis(2).Color = 'k';
legend('Terrorists','Targets')
set(gca,'fontsize',12,'fontweight','bold')

figure
subplot(1,2,1)
histogram(HI2_dm,20)
title(['Mean: ',num2str(mean(HI2_dm)),' Std: ',num2str(std(HI2_dm)),...
    ' Kurt: ',num2str(kurtosis(HI2_dm))])
hold on
histogram(HI2,20)
legend('DM perm','Real')
subplot(1,2,2)
histogram(RI2_dm,20)
hold on
histogram(RI2,20)
title(['Mean: ',num2str(mean(RI2_dm)),' Std: ',num2str(std(RI2_dm)),...
    ' Kurt: ',num2str(kurtosis(RI2_dm))])
legend('DM perm','Real')
