clc; clearvars; close all;
%% load dataset
load Target_Terror
% cambiare se rete fatta su nazione o attack type
AdjTensor = Adj_container;
Nodi1 = NodiTarget;
Nodi2 = NodiTerror;
%% opzioni
init = 1; % periodo iniziale di aggregazione
fin=5; % periodo iniziale di aggregazione
%% nodi unici
NodiA = Nodi1(init:fin);
maxcols = max(cellfun('size', NodiA, 1));  %get the number of columns of the widest array
padded = cellfun(@(a) [cell(maxcols - size(a, 1),size(a, 2));a], NodiA, 'UniformOutput', false);  %pad each array
padded2  = vertcat(padded{:});
NodiA_unici = unique(padded2);

NodiB = Nodi2(init:fin);
maxcols = max(cellfun('size', NodiB, 1));  %get the number of columns of the widest array
padded = cellfun(@(a) [cell(maxcols - size(a, 1),size(a, 2));a], NodiB, 'UniformOutput', false);  %pad each array
padded2  = vertcat(padded{:});
NodiB_unici = unique(padded2);
%% main 
Adj_big = zeros(length(NodiA_unici),length(NodiB_unici));
for t=init:fin
   A = AdjTensor{t};
   Na = Nodi1{t};
   Nb = Nodi2{t};
   for a = 1:length(Na)
       for b = 1:length(Nb)
           elem = A(a,b);
           if elem>0
               chi_a = find(strcmp(NodiA_unici,Na(a))==1);
               chi_b = find(strcmp(NodiB_unici,Nb(b))==1);
               Adj_big(chi_a,chi_b)=Adj_big(chi_a,chi_b)+elem;
           end
       end
   end
end