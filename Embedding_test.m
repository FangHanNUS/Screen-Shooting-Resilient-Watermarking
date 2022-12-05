function I_em = Embedding_test(I,W)
r = 2;
index_size = size(I,3);
%% 为彩色图像时的处理方式
if index_size ~=1
    II = rgb2ycbcr(I);
    I1 = II(:,:,1);
    %% 为灰度图时的处理方式
else
    I1 = I;
end
len = size(I1,2);
%     imshow(I1);
%% 特征点的生成（SIFT算法）
[frames,gss,dogss] = do_sift(I1, 'Verbosity', 1, 'NumOctaves', 4, 'Threshold',  0.1/3/2 ) ; % frames是一个数组，第一行是x坐标，第二行是y坐标，第三行是吃scale尺度，第四行是极值大小
frames = frames(:,find(frames(1,:)>32 & frames(1,:)<(len-32) & frames(2,:)>32 & frames(2,:)<(len-32)));
%% 特征点的筛选
EX = frames(5,:);
[A,B] = sort(EX,'descend');
for i = 1:size(frames,2)/2
    x(i) = frames(1,B(i));
    y(i) = frames(2,B(i));
    loc_x(i) = floor(x(i));
    loc_y(i) = floor(y(i));
end

%% 嵌入区域的选择
[Area,P] = find_area(I1,loc_x,loc_y,10);
%% 开始嵌入
a_num = size(Area,3);
for i = 1:a_num
    AR = Area(:,:,i);
    AR = double(AR);
    L = embed(AR,W,r);
    LL(:,:,i) = L;
    %         x = P(i,1);
    %         y = P(i,2);
    s(i) = ssim(AR,L);
end
[a,b] = sort(s,'descend');
for i = 1:5
    I1(P(b(i),2)-31:P(b(i),2)+32,P(b(i),1)-31:P(b(i),1)+32)= LL(:,:,b(i));
end
figure;imshow(I1);hold on;
for i = 1:5
    plot(P(b(i),1),P(b(i),2),'o','LineWidth',5,'MarkerEdgeColor','r');
end
if index_size ~=1
    III = II;
    III(:,:,1) = I1;
    III = ycbcr2rgb(III);
else
    III = I1;
end
I_em = III;