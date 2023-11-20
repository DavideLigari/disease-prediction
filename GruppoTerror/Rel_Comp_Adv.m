function [BigElem, MM]= Rel_Comp_Adv(T,thresh)

BigElem = cell(1,length(T));
MM = cell(1,length(T));
for t = 1:length(T)
    disp(t)
    S = T{t};
    
    n1 = (repmat(sum(S,2),1,size(S,2)));
    num = S./n1;
    num(isinf(num))=0;
    num(isnan(num))=0;
    denum = sum(S,1)./(repmat(sum(sum(S)),1,size(S,2)));
    denum(isinf(denum))=0;
    denum(isnan(denum))=0;
    RCA_S = num./repmat(denum,size(S,1),1);
    
    BigElem2= zeros(1,length(thresh));
    for tr = 1:length(thresh)
         RCA_tr2_S = zeros(size(RCA_S));
         RCA_tr_S = RCA_S;
         RCA_tr2_S(RCA_tr_S>=thresh(tr))=1;
         if thresh(tr)==1
            MM{t}= RCA_tr2_S;
         end
         BigElem2(1,tr)=sum(sum((RCA_tr2_S)));
    end
    BigElem{t}=BigElem2;
    
end