function L = do_gaussian(I,sigmaN,O,S,omin,smin,smax,sigma0)

%% file:        do_gaussian.m
 % author:      Noemie Phulpin
 % description: gaussian scale space of image I
%%
if(nargin<7) 
   sigma0=1.6*k;
end              %do_sift函数中已经定义sigma0,且输入变量宗量>7故此步不执行。

if omin<0
   for o=1:-omin
	I=doubleSize(I);
   end
elseif omin>0
   for o=1:-omin
	I=halveSize(I);
   end
end              %do_sift中已经定义omin=0，故此步不执行

[M,N] = size(I);                      %图像的尺寸

k = 2^(1/S);                          %scale space multiplicative step k
sigma0=1.6*k;                         %Lowe 定义的
dsigma0 = sigma0*sqrt(1-1/k^2);       %真正平滑用到的高斯尺度基准
sigmaN=0.5;                           %nominal smoothing of the image
so=-smin+1;                           %index offset

%scale space structure 构建尺度空间
L.O = O;
L.S = S;
L.sigma0 = sigma0;
L.omin = omin;
L.smin = smin;
L.smax = smax;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%First Octave  第一组
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 初始化第一组
L.octave{1} = zeros(M,N,smax-smin+1); 

% 初始化第一层
sig=sqrt( (sigma0*k^smin)^2 - (sigmaN/2^omin)^2 );
%b=smooth2(I,sig) ;
%[N1,M1]=size(b)
%b(1:4,1:4)
%c=imsmooth(I,sig) ;
%[N2,M2]=size(c)
%c(1:4,1:4)
L.octave{1}(:,:,1) = smooth(I,sig);

%other sub-levels 其它层
for s=smin+1:smax
    dsigma = k^s * dsigma0;
    L.octave{1}(:,:,s+so) = smooth( squeeze(L.octave{1}(:,:,s-1+so)) ,dsigma);
end    
%%只是记录下了sigma0和用到的层数，并不为每层确定具体的尺度值，具体尺度值可推导出来

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%接下来的组
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%转化所有组
for o=2:O     %接下来从第2组开始
    
    sbest = min(smin+S,smax);
    TMP = halvesize( squeeze(L.octave{o-1}(:,:,sbest+so)) );%以第四层降采样
    sigma_next = sigma0*k^smin;
    sigma_prev = sigma0*k^(sbest-S);
    
    if (sigma_next>sigma_prev)
       sig=sqrt(sigma_next^2-sigma_prev^2);
       TMP= smooth( TMP,sig);
    end       %什么情况下会出现这种状态呢？       
    
    [M,N] = size(TMP);
    L.octave{o} = zeros(M,N,smax-smin+1); %初始化下一组
    L.octave{o}(:,:,1) = TMP;             %降采样得到图像作为该组第一层
    
    %other sub-levels 其它层
    for s=smin+1:smax
        dsigma = k^s * dsigma0;
        L.octave{o}(:,:,s+so) = smooth( squeeze(L.octave{o}(:,:,s-1+so)) ,dsigma);
    end

end



%% 升降采样的定义
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Auxiliary functions

function J = halvesize(I)
J=I(1:2:end,1:2:end);

function J = doubleSize(I)
[M,N]=size(I) ;
J = zeros(2*M,2*N) ;
J(1:2:end,1:2:end) = I ;
J(2:2:end-1,2:2:end-1) = ...
	0.25*I(1:end-1,1:end-1) + ...
	0.25*I(2:end,1:end-1) + ...
	0.25*I(1:end-1,2:end) + ...
	0.25*I(2:end,2:end) ;
J(2:2:end-1,1:2:end) = ...
	0.5*I(1:end-1,:) + ...
    0.5*I(2:end,:) ;
J(1:2:end,2:2:end-1) = ...
	0.5*I(:,1:end-1) + ...
    0.5*I(:,2:end) ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

