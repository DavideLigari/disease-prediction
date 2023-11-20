function [K_B,K_L]=hid_hous(AdjMat_rist,nn)
%% hidalgo houssman
K_B = zeros(size(AdjMat_rist,1),nn);
K_L = zeros(size(AdjMat_rist,2),nn);

for n = 1:nn
    if n == 1
        K_B(:,n) = sum(AdjMat_rist,2); 
        K_L(:,n) = sum(AdjMat_rist,1); 
    else
        a1 = sum(AdjMat_rist.*(repmat(K_L(:,n-1)',size(AdjMat_rist,1),1)),2);
        b1 = (1./K_B(:,1));
        b1(isinf(b1))=0;
        b1(isnan(b1))=0;
        b1 = sparse(b1);

        a2 = sum(AdjMat_rist.*(repmat(K_B(:,n-1),1,size(AdjMat_rist,2))));
        a2 = a2';
        b2 = (1./K_L(:,1));
        b2(isinf(b2))=0;
        b2(isnan(b2))=0;
        b2= sparse(b2);

        K_B(:,n) = b1.*a1;
        K_L(:,n) = b2.*a2;
    end       
end