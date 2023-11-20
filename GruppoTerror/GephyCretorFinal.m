clc; clearvars; close all
%% posizione
Posiz = 49;
%% load final results
load('Target_TerrorNetFINAL')
Adj = Adj_Attack{end};
NodiA = NodiTerrorAttack{Posiz};
NodiB = NodiTargetAttack{Posiz};
titolo = ['Attack Network GCC ',num2str(Anni_unici(Posiz))];

Nodi = [NodiA;NodiB];
AdjNew = zeros(length(Nodi));

for x = 1:length(NodiA)
    for j = 1:length(NodiB)
        link = Adj(j,x);
        if link>0
            trovoA = find(strcmp(Nodi,NodiA(x))==1);
            trovoB = find(strcmp(Nodi,NodiB(j))==1);        
            AdjNew(trovoA,trovoB)=link;
            AdjNew(trovoB,trovoA)=link;
        end
    end
end


%% matlab visualization
G=graph(AdjNew);
GCC=conncomp(G);
[~,~,ix] = unique(GCC);
GCC_size = accumarray(ix,1).'
G.Nodes.Name = Nodi;

figure
p=plot(G,'layout','force');
highlight(p,1:length(NodiA),'NodeColor','r')
p.MarkerSize=[4*ones(length(NodiA),1);...
    repmat(4,length(NodiB),1)];
p.LineWidth = G.Edges.Weight/100;
axis off
title(titolo)
