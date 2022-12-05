%% Main_Extracting
[filename,pathname,index] = uigetfile('*.jpg;*.bmp;*.tiff');
while index == 0
    return;
end
I_em = imread([pathname,filename]);
I_em = imresize(I_em,[512,512]);
imgw = Extracting_test(I_em);
imgw = reshape(imgw,[1,64]);
w1 = imgw(1:63);
message_bit = 30;
check_bit = 7;
check_bin = [1,0,0,1,0,0,1];
ww = gf(w1);
J = bchdec(ww,63,message_bit+check_bit-1);
h=crc.detector('Polynomial',check_bin, 'InitialState', 0);
[message_data,error1] = detect(h,(J.x)');
message_data = double(message_data');
num1 = 0;
if error1 == 0
    for ii = 1:message_bit
        num1 = num1 + message_data(ii)*2^((message_bit-ii));
    end
    figure,imshow(I_em)
    title(['您的编号为：',num2str(num1,'%.0f')]);
else
    title('提取失败');
end