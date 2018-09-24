% 函数功能：A0模式下的层析成像，走时矩阵成像，把mandu(double)矩阵转换成厚度，并画出3d图
% 引用函数：S_init.m，h_analysis.m，fd_v_A0.mat，fd_v_S0.mat
% 输入：成像矩阵double，精确提取的缺陷边缘BW矩阵，兰姆波工作模式mode（1为A0，0为S0），兰姆波频率f（单位kHz），无缺陷处的厚度d0（单位mm）
% 输出：经过缺陷处铝板的厚度曲线和铝板厚度的二维图像、三维图像，整个铝板的厚度矩阵d1，缺陷处铝板厚度的平均厚度d1_mean，标准差d1_std

function [d1, d1_mean, d1_std] = thickness(double, BW, mode, f, d0)

%%%%%%%%%% 用边缘对厚度图窗口滤波 %%%%%%%%%%

% 用已经精确提取出的缺陷边缘对图像进行加窗处理，滤除double在边缘轮廓以外的所有赝像
% double(S_init(BW) == 0) = 0;

% 用已经精确提取出的缺陷边缘对缺陷内部进行滤波
% h = fspecial('average', [20 20]);
% double(S_init(BW) ~= 0) = imfilter(double(S_init(BW) ~= 0), h, 'replicate');

%%
%%%%%%%%%% A0、S0模式下的频厚积和速度关系 %%%%%%%%%%

load fd_v_A0.mat
load fd_v_S0.mat

if mode % 工作模式是A0
    fd = fd_v_A0(:, 1); %#ok<NODEF>
    v = fd_v_A0(:, 2);
else % 工作模式是S0
    fd = fd_v_S0(:, 1); %#ok<NODEF>
    v = fd_v_S0(:, 2);
end
%%
%%%%%%%%%% 把成像矩阵 double 值（慢度差）转化为A0、S0模式频率为f下厚度值 %%%%%%%%%%

% 无缺陷处的厚度是d0，兰姆波的频率为f，单位kHz，对应的无缺陷处的群速度是v0
d0 = d0 * 1e-3; % 把单位变成 m
[~, w] = min(abs(fd - f * d0));
v0 = v(w); % 单位 m/s

% v1为包含缺陷的速度值方阵，d1为包含缺陷的铝板厚度值方阵
if mode % 模式为A0模式
    v1 = 1 ./ (double + 1 / v0); % A0模式兰姆波经过缺陷变慢
else % 模式为S0模式
    v1 = 1 ./ (1 / v0 - double); % S0模式兰姆波经过缺陷变快
end
d1 = zeros(size(double, 1), size(double, 2));
for i = 1: numel(v1)
    if mode
        [~, w] = min(abs(v(1: 1617) - v1(i))); % 由于A0群速度曲线不单调，这里限制fd的范围为峰值之前
    else
        [~, w] = min(abs(v(1: 1921) - v1(i))); % 由于S0群速度曲线不单调，这里限制fd的范围为峰值之前
    end
    d1(i) = fd(w) / f * 1e3; % 单位mm
end
%%
%%%%%%%%%% 对厚度矩阵进行数据统计和图像显示 %%%%%%%%%%

% 求出边缘轮廓以内缺陷处铝板厚度的平均值d1_mean，标准差d1_std
[d1_mean, d1_std] = h_analysis(BW, d1);

% 画出铝板的厚度1d图，2d图和3d图
% figure, plot(d1(63, :)); xlim([0 128]); ylim([0, 2.5]);
% set(gca, 'xtick', 0: 20: 128, 'xticklabel', 0: 50: 320, 'ytick', 0: 0.5: 2.5);
figure, imagesc(d1), colormap(gray), axis image
set(gca, 'xtick', 0: 20: 128, 'xticklabel', 0: 50: 320, 'ytick', 8: 20: 128, 'yticklabel', 300: -50: 0);
figure, mesh(d1), zlim([0, max(max(d1))])
set(gca, 'xtick', [0 128], 'xticklabel', [0 320], 'ytick', [0 128], 'yticklabel', [320 0]);

end