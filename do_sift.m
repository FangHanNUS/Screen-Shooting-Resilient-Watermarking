function [frames,scalespace,difofg]=do_sift(I,varargin)
%% file:       sift.m
% author:      Noemie Phulpin
% description: SIFT algorithm
warning off all;
[M,N,C] = size(I) ;
% Lowe's choices
S=3;
omin= 0 ;
%O=floor(log2(min(M,N)))-omin-4 ; % Up to 16x16 images
O = 4;
sigma0=1.6*2^(1/S) ;
sigmaN=0.5 ;
thresh = 0.2 / S / 2 ; % 0.04 / S / 2 ;
r = 18 ;
NBP = 4 ;
NBO = 8 ;
magnif = 3.0 ;
% Parese input
compute_descriptor = 0 ;
discard_boundary_points = 1 ;
verb = 0 ;
% Arguments sanity check
if C > 1
  error('I 应该是灰度图') ;
end
frames = [] ;
descriptors = [] ;
% 
%   开始工作
%
% fprintf('---------------------------- 开始 SIFT: 从图像中提取SIFT特征 ------------------------------\n') ; tic ; 
% fprintf('SIFT: 用DoG构造尺度空间 ...\n') ; tic ; 
scalespace = do_gaussian(I,sigmaN,O,S,omin,-1,S+1,sigma0) ;
% fprintf('                高斯尺度空间计时: (%.3f s)\n',toc) ; tic ; 
difofg = do_diffofg(scalespace) ;
% fprintf('                构建相减尺度空间: (%.3f s)\n',toc) ;
for o=1:scalespace.O
% 	fprintf('CS5240 -- SIFT: 计算 “组”  %d\n', o-1+omin) ;
%                 tic ;
  %  DOG octave 的局部极值检测
    oframes1 = do_localmax(  difofg.octave{o}, 0.8*thresh, difofg.smin  ) ;
    oframes2 = do_localmax( -difofg.octave{o}, 0.8*thresh, difofg.smin  ) ;
	oframes = [oframes1 ,oframes2 ] ;  
%     fprintf('CS5240 -- SIFT: 初始化关键点 # %d.  \n', ...
      size(oframes, 2) ;
%     fprintf('                用时 (%.3f s)\n', ...
%        toc) ;
%     tic ;
    if size(oframes, 2) == 0
        continue;
    end
  % 移除靠近边界的关键点
    rad = magnif * scalespace.sigma0 * 2.^(oframes(3,:)/scalespace.S) * NBP / 2 ;
    sel=find(...
      oframes(1,:)-rad >= 1                     & ...
      oframes(1,:)+rad <= size(scalespace.octave{o},2) & ...
      oframes(2,:)-rad >= 1                     & ...
      oframes(2,:)+rad <= size(scalespace.octave{o},1)     ) ;
    oframes=oframes(:,sel) ;%把不是靠近边界点的极值点重新放入oframes中
% 	fprintf('CS5240 -- SIFT: 移除靠近边界关键点后 # %d \n', size(oframes,2)) ;
%       tic ;		
% 精简局部, 阈值强度 和移除边缘关键点
   	oframes = do_extrefine(...
 		oframes, ...
 		difofg.octave{o}, ...
 		difofg.smin, ...
 		thresh, ...
 		r) ;
%    	fprintf('CS5240 -- SIFT:  移除低对比度和边缘上关键点后 # %d \n',size(oframes,2)) ;
%     fprintf('                Time (%.3f s)\n',  toc) ;
%     tic ;
%   
%     fprintf('CS5240 -- SIFT: 计算特征点方向\n');
  % 计算方向
% 	oframes = do_orientation(...
% 		oframes, ...
% 		scalespace.octave{o}, ...
% 		scalespace.S, ...
% 		scalespace.smin, ...
% 		scalespace.sigma0 ) ;
% 	fprintf('                用时: (%.3f s)\n', toc);tic;
  % Store frames
	x     = 2^(o-1+scalespace.omin) * oframes(1,:) ;
	y     = 2^(o-1+scalespace.omin) * oframes(2,:) ;
% 	sigma = 2^(o-1+scalespace.omin) * scalespace.sigma0 * 2.^(oframes(3,:)/scalespace.S) ;	%图像的尺度	
    sigma = oframes(3,:);
    clear ooo;
    for oo = 1:size(x,2)
        ooo(oo) = o;
    end
	frames = [frames, [x(:)' ; y(:)' ; sigma(:)' ; ooo(:)' ; oframes(4,:) ] ] ;
% 	fprintf('CS5240 -- SIFT:计算方向后的特征点 # %d  \n', size(frames,2)) ;
%   % Descriptors
% 	
%     fprintf('CS5240 -- SIFT: 计算 描述子...\n') ;
%     tic ;
% 		
% 	sh = do_descriptor(scalespace.octave{o}, ...
%                     oframes, ...
%                     scalespace.sigma0, ...
%                     scalespace.S, ...
%                     scalespace.smin, ...
%                     'Magnif', magnif, ...
%                     'NumSpatialBins', NBP, ...
%                     'NumOrientBins', NBO) ;
%     
%     descriptors = [descriptors, sh] ;%每一组计算描述子向量后补充到descriptors数组中
%     
%     fprintf('                用时: (%.3f s)\n\n\n',toc) ; 
%     
%       
%     
end 
% 
% fprintf('CS5240 -- SIFT: 关键点总数: %d \n\n\n', size(frames,2)) ;
