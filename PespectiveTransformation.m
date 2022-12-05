%% 主函数
clear;clc;
close all;
[filename, pathname, index] = uigetfile('*.bmp;*.jpg;*.png');
test_image = im2double(imread([pathname,filename]));
n = 512;m = 512;% 需要将图像恢复的尺寸：m*n
imshow([test_image(:,:,:)]);hold on;
for p = 1:4
    [loc_x(p),loc_y(p)] = ginput(1);
    plot(loc_x(p),loc_y(p),'r.');
end
loc_x = floor(loc_x);
loc_y = floor(loc_y);
%% 对筛选出的四个点坐标进行排序
[X,Y] = my_sort(loc_x,loc_y,test_image);
%% 对原图像进行透视变换
img = imread(strcat(pathname,filename));
I = my_pres_trans(img,X,Y,m,n);
%% 写图像
k = find(filename == '.');
pathfile=[pathname,[filename(1:k-1),'_re.png']];
imwrite(I,pathfile);

 