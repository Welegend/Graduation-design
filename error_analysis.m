% 函数功能：对二维的缺陷轮廓求标准差BW_std，补偿系数BW_k，最小标准差BW_std_min
% 引用函数：无
% 输入：BW轮廓矩阵
% 输出：标准差BW_std，补偿系数BW_k，最小标准差BW_std_min

function [BW_std, BW_k, BW_std_min] = error_analysis(BW) % function语句必须要放到第一句

[x, y] = find(BW == 1);

% 将坐标系原点设在圆心处，方便进行缩放
x1 = x - 64.5;
y1 = y - 64.5;

% 求标准差函数z-k
k = 0: .01: 2;
z = sqrt(mean((sqrt((x1 * k) .^ 2 + (y1 * k) .^ 2) - 12) .^ 2)); % 对轮廓点集和实际缺陷的半径差求方均根，得到的单位是网格
z = z * 320 / 128; % 将误差分析单位转化为mm

% 求原轮廓的标准差std
BW_std = z(101);

% 求使标准差函数最小的补偿系数BW_k，最小标准差BW_std_min
BW_std_min = min(z);
BW_k = k(z == BW_std_min);        %这里本来用了find，后来发现可以不用

%{
% 用求出来的补偿系数求补偿后的边缘矩阵BW_b，并成像
x2 = x1 * BW_k;
y2 = y1 * BW_k;
x3 = x2 + 64.5;
y3 = y2 + 64.5; % 将坐标系原点还原到左上角，使其符合矩阵下标的索引
x4 = floor(x3);
y4 = floor(y3); % 将缩放后的轮廓坐标取整
BW_b = zeros(128, 128);

% 将横坐标为x4，纵坐标为y4的元素赋值为1
n = length(x4);
for i = 1: n
       BW_b(x4(i), y4(i)) = 1;
end

% 显示出补偿后的轮廓图像
% figure, imagesc(BW_b), colormap(gray), axis image
%}
end