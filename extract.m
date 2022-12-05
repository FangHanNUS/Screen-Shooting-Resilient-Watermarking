% extratest
function Y = extract(L,m)
ww = zeros(m,m);
for i = 1:m
    for j = 1:m
        A = L((i-1)*8+1:8*i,(j-1)*8+1:8*j);
        AA = dct2(A);
        C1 = AA(4,5);
        C2 = AA(5,4);
        if C1 > C2
            ww(i,j) = 0;
        else 
            ww(i,j) = 1;
        end
    end
end

Y = ww;