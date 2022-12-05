%%%%%%%%%%%%%%%%%
% ¶ÔÍ¼ÏñÇ¶ÈëË®Ó¡ %
%%%%%%%%%%%%%%%%%
function LLL = embed(L,ww,r)
[m,n] = size(ww);
LL = L;
for i = 1:m
    for j = 1:n
        A = L((i-1)*8+1:8*i,(j-1)*8+1:8*j);
        AA = dct2(A);
        C1 = AA(4,5);
        C2 = AA(5,4);
        if ww(i,j) == 0
            if(C1 > C2)
            else
                C = C1;
                C1 = C2;
                C2 = C;
            end
        else
            if(C1 > C2)
                C = C1;
                C1 = C2;
                C2 = C;
            else
            end
        end
        delta = (5/11424)*(C1*51+C2*56) + r * 26.75;
        if C1 > C2
            CC1 = C1 + delta ;
            CC2 = C2 - delta ;
%             CC1 = C1 + 0.025 * ( C1 + C2 ) + 12 * r;
%             CC2 = C2 - 0.025 * ( C1 + C2 ) - 12 * r;
        else
            CC1 = C1 - delta ;
            CC2 = C2 + delta ;
%             CC1 = C1 - 0.025 * ( C1 + C2 ) - 12 * r;
%             CC2 = C2 + 0.025 * ( C1 + C2 ) + 12 * r;
        end
        AA(4,5) = CC1;
        AA(5,4) = CC2;
        AAA = idct2(AA);
        LL((i-1)*8+1:8*i,(j-1)*8+1:8*j) = AAA;
    end
end
LLL = LL;