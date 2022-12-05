%% This is the code for: Fang, Han, et al. "Screen-shooting resilient watermarking." IEEE Transactions on Information Forensics and Security 14.6 (2018): 1403-1418.
%% Email: fanghan@mail.ustc.edu.cn / fanghan@nus.edu.sg
%% 
%% Embedding Process
run "Main_Embed.m", choosing the image to be embedded, then typing the message you want to embed. You will get the watermarked image named 'Embed.bmp'.

%% Extraction Process
1. Performing the perspective transformation with "PerspectiveTransformation.m", then choosing the photo, clicking the four corner of the image to conduct the transform.
2. run "Main_Extract.m", choosing the perspective transformed image, the results will be shown in the title.
