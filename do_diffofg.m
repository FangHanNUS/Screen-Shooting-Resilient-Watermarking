function D = do_diffofg(L)

%% file:        do_diffofg.m
 % author:      Noemie Phulpin
 % description: substraction of consecutive levels of the scale space SS.
 %%


D.smin = L.smin;
D.smax = L.smax-1;
D.omin =L.omin;
D.O = L.O;
D.S = L.S;
D.sigma0 = L.sigma0;

for o=1:D.O
    
    [M,N,S] = size(L.octave{o});
    D.octave{o} = zeros(M,N,S-1);
    
    for s=1:S-1
        D.octave{o}(:,:,s) = L.octave{o}(:,:,s+1) -  L.octave{o}(:,:,s);   
    end;
    
end;
