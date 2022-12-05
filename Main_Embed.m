%% Main_Embed
clear;clc;close all
[filename,pathname,index] = uigetfile('*.jpg;*.bmp;*.tiff;*.png');
while index == 0
    return;
end
I = imread([pathname,filename]);
check_bin = [1,0,0,1,0,0,1];%CRC8
a = input('请输入需要嵌入的水印序列（0~1073741824）：');
% a = 20200421;
message_bit = 30;
if a >= 2^message_bit
    error('Wrong Input!');
end
j = dec2bin(a);
len = length(j);
for i = 1:message_bit
    if i <= len
        J(message_bit-i+1) = str2num(j(len-i+1));
    else
        J(message_bit-i+1) = 0;
    end
end
h = crc.generator('Polynomial',check_bin, 'InitialState', 0);
data = generate(h,J');
matrix_a = gf(data'); 
JJ = bchenc(matrix_a,63,36);
JJJ = JJ.x;
W = JJJ;
W(64) = 0;
W = reshape(W,[8 8]);
tic;
I_em = Embedding_test(I,W);
toc;
imshow(I_em)
imwrite(uint8(I_em),[filename,'_Embed.bmp']);