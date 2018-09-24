% 函数功能：板厚2mm，缺陷1mm，求出理论上兰姆波在每一个发射探头到接收探头的路径上经过缺陷的走时或幅值数据delta，以及实际缺陷的边缘轮廓
% 引用函数：fd_v_A0.mat，fd_v_S0.mat
% 输入：实际的板宽a (单位mm)；实际的缺陷直径d (单位mm)；兰姆波工作模式mode，1为A0，0为S0；
%       选择信息的类型info，1为走时信息，0为幅值信息；兰姆波工作频率f (单位kHz)，路径矩阵lujing(行为路径条数，列为网格个数)
% 输出：理论走时或幅值的列向量delta，理论缺陷的边缘矩阵BW

function [delta, BW] = lilundelta(a, d, mode, info, f, lujing)

% 每侧探头数量num_tan，分网大小num_grid（每边）
num_tan = sqrt(size(lujing, 1));
num_grid = sqrt(size(lujing, 2));

%%%%%%%%%% 计算给定模式给定工作点，有缺陷和无缺陷处的理论速度 %%%%%%%%%%

load fd_v_A0.mat
load fd_v_S0.mat

if mode % 工作模式是A0
    fd = fd_v_A0(:, 1); %#ok<NODEF>
    v = fd_v_A0(:, 2);
else % 工作模式是S0
    fd = fd_v_S0(:, 1); %#ok<NODEF>
    v = fd_v_S0(:, 2);
end

% 无缺陷处的厚度是d0，兰姆波的频率为f，单位kHz，对应的无缺陷处的群速度是v0
d0 = 2e-3; % 单位 米
[~, w] = min(abs(fd - f * d0));
v0 = v(w); % 单位 m/s

% 有缺陷处的厚度是d1，兰姆波的频率为f，单位kHz，对应的有缺陷处的群速度是v1
d1 = 1e-3; % 单位 米
[~, w] = min(abs(fd - f * d1));
v1 = v(w); % 单位 m/s

%%
%%%%%%%%%% 理论的走时和幅值矩阵 %%%%%%%%%%

a_h = (num_tan + 1) / 2; % 板宽的一半
r = (d / a) * (num_tan + 1) / 2; % 圆形缺陷的半径
D = zeros(num_tan, num_tan); % 用来得到每条路径发射探头和接收探头的位置

% 求出每条路径到圆心的距离
[x, y] = find(D == 0); % 找到每条路径发射接收探头位置
k = (y - x) / (num_tan + 1); % 当坐标原点设在铝板左下角时，每条路径的斜率
b = x; % 每条路径的截距
D_l = abs(k * a_h - a_h + b) ./ sqrt(k .^ 2 + 1 ^ 2); % 每条路径到圆心的距离，为列向量

% 根据路径到圆心的距离，算出走时差和幅值差
if info
    % 走时差
    delta = zeros(num_tan * num_tan, 1); %用来存放走时差数据
    delta(D_l <= r) = 2 * sqrt(r ^ 2 - D_l(D_l <= r) .^ 2) * a / (num_tan + 1) / 1000 * abs(1 / v0 - 1 / v1);
    % (1 / 2833.4 - 1 / 3126.4); % 0.42 MHz A0速度
    % (1 / 2860.3 - 1 / 3136.8); % 0.44 MHz A0速度
    % (1 / 2317.2 - 1 / 2803.2); % 0.2 MHz A0速度
    % (1 / 3424.4 - 1 / 5200.6); % 0.96 MHz S0速度
else
    % 幅值比值
    delta = (D_l <= r) * 0.4; % 经过缺陷的幅值的衰减系数
    delta(D_l > r) =  0; % 未经过缺陷的幅值无衰减
end
%%
%%%%%%%%%% 理论的边缘矩阵BW %%%%%%%%%%

% 扫描num_grid * num_grid的方阵，把每一格的半径算出来
r = zeros(num_grid, num_grid);
[x, y] = find(r == 0);
r_l = sqrt((x - (num_grid + 1) / 2) .^ 2 + (y - (num_grid + 1) / 2) .^ 2); % 每一格到圆心的半径
r(:) = r_l(:); % 把列向量r_l的数放到方阵r里

% 保留r上半径小于等于 d / a * num_grid 的点
BW = (r <= (d / a * num_grid) / 2);

% 提取边缘矩阵BW
BW = edge(BW);

end