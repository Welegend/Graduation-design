% 函数功能：铝板的缺陷深度为1mm，对实验中缺陷处铝板厚度求平均厚度d1_mean，标准差d1_std
% 引用函数：无
% 输入：BW轮廓矩阵和厚度图
% 输出：缺陷处铝板厚度的平均厚度d1_mean，标准差d1_std

function [d1_mean, d1_std] = h_analysis(BW, d1)

% 设和BW等大的矩阵mandu
[x, y] = size(BW);
mandu = zeros(x, y);

% i按列扫描，求出边缘矩阵存在1的列区域w1:w2
[~, w1] = find(any(BW), 1 ); % 找出BW存在1区域的最小列
[~, w2] = find(any(BW), 1, 'last' ); % 找出BW存在1区域的最大列
for i = w1: w2
    mandu(find(BW(:, i), 1): find(BW(:, i), 1, 'last'), i) = 1;
end

% 缺陷内部厚度的平均值和铝板厚度的标准差
d1 = d1(mandu == 1);
d1_mean = mean(d1(:));
d1_std = sqrt(mean((d1(:) - 1) .^ 2));

end