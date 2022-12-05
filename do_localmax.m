function J = do_localmax(octave, thresh,smin)

%% file:       do_localmax.m
% author:      Noemie Phulpin
% description: returns the indexes of the local maximizers of the octave.
%%
[N,M,S]=size(octave); 
nb=1;
k=0.0002;
% for each point of this scale space         对于尺度空间的每一个点我们
% we look for exterma bigger than thresh    寻找比阈值大的极值点
J = [];
for s=2:S-1
    for j=20:M-20
        for i=20:N-20
             a=octave(i,j,s); 
%             V = [ thresh octave(i-1,j-1,s-1) octave(i-1,j,s-1) octave(i-1,j+1,s-1) octave(i,j-1,s-1) octave(i,j+1,s-1) octave(i+1,j-1,s-1) octave(i+1,j,s-1) octave(i+1,j+1,s-1) octave(i-1,j-1,s) octave(i-1,j,s) octave(i-1,j+1,s) octave(i,j-1,s) octave(i,j+1,s) octave(i+1,j-1,s) octave(i+1,j,s) octave(i+1,j+1,s) octave(i-1,j-1,s+1) octave(i-1,j,s+1) octave(i-1,j+1,s+1) octave(i,j-1,s+1) octave(i,j+1,s+1) octave(i+1,j-1,s+1) octave(i+1,j,s+1) octave(i+1,j+1,s+1)];
%             maximum=max(V);
            % &&是标量关系表达式的避绕式 与操作
            if a>thresh+k ...    %a>阈值，接下来比较a是否大于所有26邻域点，
                    && a>octave(i-1,j-1,s-1)+k && a>octave(i-1,j,s-1)+k && a>octave(i-1,j+1,s-1)+k ...
                    && a>octave(i,j-1,s-1)+k && a>octave(i,j+1,s-1)+k && a>octave(i+1,j-1,s-1)+k ...
                    && a>octave(i+1,j,s-1)+k && a>octave(i+1,j+1,s-1)+k && a>octave(i-1,j-1,s)+k ...
                    && a>octave(i-1,j,s)+k && a>octave(i-1,j+1,s)+k && a>octave(i,j-1,s)+k ...
                    && a>octave(i,j+1,s)+k && a>octave(i+1,j-1,s)+k && a>octave(i+1,j,s)+k ...
                    && a>octave(i+1,j+1,s)+k && a>octave(i-1,j-1,s+1)+k && a>octave(i-1,j,s+1)+k ...
                    && a>octave(i-1,j+1,s+1)+k && a>octave(i,j-1,s+1)+k && a>octave(i,j+1,s+1)+k ...
                    && a>octave(i+1,j-1,s+1)+k && a>octave(i+1,j,s+1)+k && a>octave(i+1,j+1,s+1)+k
%            if a-maximum>0.00004
            %if (a-maximum>0.001)
                J(1,nb)=j-1; 
                J(2,nb)=i-1; 
                J(3,nb)=s+smin-1;
                J(4,nb)=a;
                nb=nb+1;
            end
        end
    end
end