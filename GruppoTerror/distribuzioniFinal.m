clc; clearvars; close all
%% load final results
load('Target_TerrorNetFINAL')
%% attack
Adj=Adj_Attack;

Str_A=zeros(length(Adj),1);
Str_B=zeros(length(Adj),1);

Str_Adistr=cell(length(Adj),2);
Str_Bdistr=cell(length(Adj),2);


for t = 1:length(Adj)
   Net = Adj{t};
   
    [f,x] = ecdf(sum(Net,1),'Function','survivor');
    Str_Adistr{t,1}=f;
    Str_Adistr{t,2}=x;  
    
    Str_A(t) = log(x(1:end-1))\log(f(1:end-1));
    
    [f,x] = ecdf(sum(Net,2),'Function','survivor');
    Str_Bdistr{t,1}=f;
    Str_Bdistr{t,2}=x;  
    Str_B(t) = log(x(1:end-1))\log(f(1:end-1));
end

%% victim
Adj=Adj_Victim;

Str_AV=zeros(length(Adj),1);
Str_BV=zeros(length(Adj),1);

Str_AVdistr=cell(length(Adj),2);
Str_BVdistr=cell(length(Adj),2);

for t = 1:length(Adj)
   Net = Adj{t};
   
    [f,x] = ecdf(sum(Net,1),'Function','survivor');
    Str_AVdistr{t,1}=f;
    Str_AVdistr{t,2}=x;   
    Str_AV(t) = log(x(1:end-1))\log(f(1:end-1));
    
    [f,x] = ecdf(sum(Net,2),'Function','survivor');
    Str_BVdistr{t,1}=f;
    Str_BVdistr{t,2}=x;
    Str_BV(t) = log(x(1:end-1))\log(f(1:end-1));
end

%% distrib
calormap=turbo(length(Str_Adistr));
figure
subplot(2,2,1)
for u=1:length(Str_Adistr)
    loglog(Str_Adistr{u,2},Str_Adistr{u,1},'color',calormap(u,:),'linewidth',.5)
    hold on
end
grid on
axis square
title('HI level-1 survival distribution')
set(gca,'fontsize',12,'fontweight','bold')

subplot(2,2,2)
for u=1:length(Str_Bdistr)
    loglog(Str_Bdistr{u,2},Str_Bdistr{u,1},'color',calormap(u,:),'linewidth',.5)
    hold on
end
grid on
axis square
title('RI level-1 survival distribution')
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




figure
subplot(2,2,1)
for u=1:length(Str_AVdistr)
    loglog(Str_AVdistr{u,2},Str_AVdistr{u,1},'color',calormap(u,:),'linewidth',.5)
    hold on
end
grid on
axis square
title('HI level-1 survival distribution')
set(gca,'fontsize',12,'fontweight','bold')


subplot(2,2,2)
for u=1:length(Str_BVdistr)
    loglog(Str_BVdistr{u,2},Str_BVdistr{u,1},'color',calormap(u,:),'linewidth',.5)
    hold on
end
grid on
axis square
title('RI level-1 survival distribution')
lgn = legend(string(num2str([1970:1992,1994:2019]'))...
,'NumColumns',5,'location','southoutside');
title(lgn,'Years')
set(gca,'fontsize',12,'fontweight','bold')

subplot(2,2,3:4)
plot(-1+Str_AV,'d-.','linewidth',2,'color',[0 0 0])
hold on
plot(-1+Str_BV,'s-.','linewidth',2,'color',[0.7 0.7 0.7])
title('Power Law Fit Exponents')
legend('Terrorists','Targets')
xticks(1:2:length(Anni_unici))
xticklabels(Anni_unici(1:2:end))
xtickangle(30)
axis tight
grid on
ylabel('Exponents')
set(gca,'fontsize',12,'fontweight','bold')
