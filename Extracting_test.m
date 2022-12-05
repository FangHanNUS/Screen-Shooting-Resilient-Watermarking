function imgw = Extracting_test(I0)
index_size = size(I0,3);
len = 512;
II1 = I0;
if index_size ~=1
    II = rgb2gray(II1);
    I1 = II(:,:,1);
%% 为灰度图时的处理方式
else
    I1 = II1;
end
II = I1;
[frames,gss,dogss] = do_sift(II, 'Verbosity', 1, 'NumOctaves', 4, 'Threshold',  0.1/3/2 ) ; % frames是一个数组，第一行是x坐标，第二行是y坐标，第三行是吃scale尺度，第四行是极值大小
frames = frames(:,find(frames(1,:)>32 & frames(1,:)<(len-32) & frames(2,:)>32 & frames(2,:)<(len-32)));
FR = frames';
%% 初始化水印信息
block = 8;
W = zeros(block,block);
%% 特征点的筛选
EX = frames(5,:);
[A,B] = sort(EX,'descend');
FR = sortrows(FR,-5);
index = 1;
i = 2;
x(1) = frames(1,B(1));
y(1) = frames(2,B(1));
while index < 10
    for i = index+1:size(FR,1)
        if abs((FR(i,1) - x(index))) <= 64 && abs((FR(i,2) - y(index))) <= 64
            FR(i,5) = 0;
        else
        end
    end
    FR = FR( find(FR(:,5) ~= 0),1:5 );
    index = index + 1;
    x(index) = FR(index,1);
    y(index) = FR(index,2);
end
% figure;imshow(II);hold on
% for i = 1:10
%     plot(x(i),y(i),'o','LineWidth',1,'MarkerEdgeColor','r');
% end
%% 提取区域的选择
xx(1:10) = x(1:10);yy(1:10) = y(1:10);
Area = find_area_extract(II,xx,yy);
a_num = size(Area,3);
sub_a_num = size(Area,4);
for i = 1:a_num
    for j = 1:sub_a_num
        AR = Area(:,:,i,j);
        AR = double(AR);
        w = extract(AR,8);
        w_group(:,:,i,j) = w;
    end
end
index = 1;ber_point1 = [];ber_point2 = [];qq = 0;
W_final_1 = w_group(:,:,1,1);W_final_2 = w_group(:,:,1,2);min_num = biterr(W_final_1,W_final_2);
%% 取出距离最近的两个数
for j = 1:sub_a_num-1
    for jj = j+1:sub_a_num
        for i = 1:a_num
            for ii = 1:a_num
                W1 = w_group(:,:,i,j);
                W2 = w_group(:,:,ii,jj);
                judge_num = biterr(W1,W2);
                if judge_num < min_num
                    W_final_1 = W1;
                    W_final_2 = W2;
                    min_num = judge_num;
                end
            end
        end
    end
end
imgw = W_final_1;