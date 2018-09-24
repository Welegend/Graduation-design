%{
% 函数功能：在得到路径矩阵和走时差（幅值差）矩阵之后，用sirt迭代算法对缺陷成像，一般情况下S = 0
% 引用函数：无
% 输入：路径矩阵lujing，走时差（幅值差）列向量delta
% 输出：双跨孔的慢度矩阵double和所成的灰度图
% 心得：迭代的速度较慢，于是我想到了matlab的循环运算变矩阵运算；
       但是，这不是绝对的，如果矩阵运算扩展了不必要的维度，变成了超大矩阵，而且这个运算在一个循环里反复出现，那么反而会更慢，
       例如，一个方阵的列和一个列向量依次点乘，如果为了矩阵运算，把列向量复制成方阵，那么反而会更慢
%}

function double = chengxiang_fb(lujing, delta)

%%%%%%%% 以下是sirt求慢度程序 %%%%%%%%

% L是路径矩阵，T是走时差矩阵，要解T = L * S的方程组
L = lujing;
T = abs(delta);

% 预设出sirt公式里的变量
[m, n] = size(L); % m条射线，n个网格
S = ones(n, 1) * 0; % sirt算法可以收敛到不同值，这里可以改变0，输入先验经验即初始值
L_square = sum(L .^ 2, 2); % L矩阵每行的平行之和，是个列向量，用来算权重
N = sum(L ~= 0); % N是L矩阵列不为0的个数，即每个网格通过的射线条数，用来反投影
Wi = L ./ L_square(:, ones(1, n)) ./ N(ones(m, 1), :); % 求出每条投影线对每个网格修正的权重，然后反投影
delta_S = zeros(n, 1); % 慢度的修正值

k = 0; % 迭代次数
fl = 1; % 迭代精度标志位

% sirt迭代主程序
while (fl && k < 100)
    P = L * S; % 和公式里的P意义相同，实际的投影值
    delta_T = T - P; % 每条投影线的修正
    
    % 计算本次迭代所有网格的修正值
    for j = 1: n
        delta_S(j) = sum(delta_T .* Wi(:, j)); % 对每条投影线的修正加权平均，然后反投影
    end
    delta_S(isnan(delta_S)) = 0; % N中有0元素，此语句为避免出现NaN
    S = S + delta_S;
    
    % 判断是否所有网格的修正值都小于1e-8
    if all(abs(delta_S) <= 1e-8)
        fl = 0;
    end
    
    % 迭代次数加一
    k = k + 1;
end

% 得到sirt迭代后的慢度列向量mandu
mandu = S; % 这里不加绝对值，在deltazoushi上加
%% 
%%%%%%%%%% 以下是成像程序 %%%%%%%%%%

num_grid = sqrt(size(lujing, 2)); % 分网大小num_grid（每边）

% 对mandu进行处理变成方阵：双跨孔矩阵double
single = reshape(mandu, num_grid, num_grid);
double = (single + rot90(single)) ./ 2;

% 简单的阈值滤波
double(abs(double) <= 0) = 0;

% 对double矩阵成灰度图
figure, imagesc(double), colormap(gray), axis image

% xtick就是你要在哪些值处显示刻度，xticklabel就是指定显示为什么  
set(gca, 'xtick', 0: 20: 128, 'xticklabel', 0: 50: 320, 'ytick', 8: 20: 128, 'yticklabel', 300: -50: 0);

% clearvars -except double delta deltazoushi deltafuzhi delta_f lujing_28 mandu

end
%{
其他绘图命令：
mesh(double);     % 画出3D图
surf(double,'EdgeColor','None');  % 绘制双跨孔时的3D图
contour(single,5)  % 等高线图
shading interp;     % 通过不同的线面之间插值使画出的图颜色平滑
%}