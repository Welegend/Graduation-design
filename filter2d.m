% 函数功能：对求出来的缺陷图像求二维的滤波图像，并对二维的缺陷图像求标准差std，补偿系数k_final，最小标准差z_min
% 引用函数：error_analysis.m
% 输入：double成像矩阵
% 输出：标准差BW_std，补偿系数BW_k，最小标准差BW_std_min，图像的边缘方阵BW

function [BW, BW_std, BW_k, BW_std_min] = filter2d(double)

% 先归一化，然后用伽马函数对图像进行亮度变换凸显比较亮（数值大）的部分
I = mat2gray(double);
I = imadjust(I, [], [], 3); %%%%% 这个参数需要多次调整

% 简单的阈值滤波得到I
I(I <= 0.1) = 0;

% 中值滤波得到gs
gs = medfilt2(I, [15, 15]); %%%%% 这个参数需要多次调整
gs = mat2gray(gs);


% 对图像进行对比度变换得到g
E = 20;
m = 0.3;
g = 1 ./ (1 + (m ./ (gs + eps)) .^ E);

% 此处需加上边缘检测得到BW，小于某一值的缺陷不检测（实验精度达不到）
[BW, ~] = edge(g, 'sobel');

% 各种图像滤波
% h = fspecial('gaussian');
% chengxiang = imfilter(I, h, 'replicate');


% 显示出各个滤波过程中的图像
% figure, imagesc(I), colormap(gray), axis image % 伽马函数变换和阈值滤波后的图像
% set(gca, 'xtick', 0: 20: 128, 'xticklabel', 0: 50: 320, 'ytick', [8: 20: 128], 'yticklabel', 300: -50: 0);
% figure, imagesc(gs), colormap(gray), axis image % 中值滤波后的图像
% set(gca, 'xtick', 0: 20: 128, 'xticklabel', 0: 50: 320, 'ytick', [8: 20: 128], 'yticklabel', 300: -50: 0);
% figure, imagesc(g), colormap(gray), axis image % 对比度变换后的图像
% set(gca, 'xtick', 0: 20: 128, 'xticklabel', 0: 50: 320, 'ytick', [8: 20: 128], 'yticklabel', 300: -50: 0);
figure, imagesc(BW), colormap(gray), axis image % 缺陷的边缘
set(gca, 'xtick', 0: 20: 128, 'xticklabel', 0: 50: 320, 'ytick', [8: 20: 128], 'yticklabel', 300: -50: 0);

% 求出标准差，画出补偿后的边缘图像
[BW_std, BW_k, BW_std_min] = error_analysis(BW);

end