% 读取秘密信息文件和测试图像文件
msg = 'message_short.txt'; % 秘密信息文件路径
test = 'lena_color_256.tiff'; % 测试图像文件路径

% 按位读取秘密信息
frr=fopen(msg,'r');
[message,~]=fread(frr,'ubit1'); % 以ubit1格式读取秘密信息
fclose(frr);

% 定义压缩质量比从10%到100%
quality=10:10:100;
index=1;

% 信息嵌入
[count,message,hideresult]=dcthide_rand(test,msg,10,2019); % 使用DCT算法将秘密信息嵌入测试图像中

% JPEG压缩
for q=quality
    different=0;
    imwrite(uint8(hideresult),'temp.jpg','Quality',q); % 将带有嵌入信息的图像保存为JPEG格式
    msgextract=dctget_rand('temp.jpg','temp.txt',count,2019); % 从JPEG图像中提取秘密信息
    for i=1:count
        if message(i,1)~=msgextract(i,1)
            different=different+1;
        end
    end
    result(index)=different/count; % 计算提取的信息与原始信息不同的百分比例
    index=index+1;
end

% 绘制结果
figure;
plot(quality,result,'-r'); % 绘制抵抗JPEG压缩能力分析图

xlabel('QF'); % X轴标签，QF代表JPEG压缩的质量因子
ylabel('提取的信息与原始信息不同的百分比例'); % Y轴标签
title('DCT算法抵抗JPEG压缩能力分析'); % 图标题
