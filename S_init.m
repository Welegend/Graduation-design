% 函数功能：在求出缺陷轮廓BW的基础上，将轮廓内部的数据变为1，从而将其作为sirt.m迭代的慢度初值，修正sirt算法的不足造成的误差
% 引用函数：无
% 输入：缺陷轮廓BW矩阵
% 输出：轮廓内部全为1的一维列向量S
% 效果：经过验证发现，在sirt一次迭代时，初值设为迭代后的目标值值效果最好；多次迭代之后，慢度初值对结果的影响减弱，但仍是设为目标值效果最好

function S = S_init(BW)

% 设和BW等大的矩阵mandu
[x, y] = size(BW);
mandu = zeros(x, y);

% i按列扫描，求出边缘矩阵存在1的列区域w1:w2
[~, w1] = find(any(BW), 1 ); % 找出BW存在1区域的最小列
[~, w2] = find(any(BW), 1, 'last' ); % 找出BW存在1区域的最大列
for i = w1: w2
    mandu(find(BW(:, i), 1): find(BW(:, i), 1, 'last'), i) = 3.39e-5;
    %%%%% 这个参数需要多次调整，对于理论A0模式0.42 MHz走时，该数为3.39e-5，对于实验A0模式0.42 MHz，该数为2.94e-5
    %%%%% 实验A0模式0.2 MHz，该数为1.87e-5，理论A0模式0.2 MHz，该数为7.67e-5
end

% 画出修正后的慢度灰度图
% figure, imagesc(mandu), colormap(gray), axis image
% set(gca, 'xtick', [], 'ytick', []); % 不显示x、y轴的坐标刻度

% 将矩阵mandu转化成列向量
S = mandu(:);