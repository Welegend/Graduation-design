% 函数功能：将板分网，左右两侧均匀等间距布置探头，求SIRT迭代的路径矩阵
% 引用函数：无
% 输入：每侧探头数量num_tan，分网大小num_grid（每边），实际板宽a (单位毫米)
% 输出：SIRT迭代的路径矩阵lujing，SIRT迭代初值S

function lujing = L_matrix(num_tan, num_grid, a) % 这里建模num_tan + 1为板宽
%% 建立射线方程y = k * x + b，划分网格

D = zeros(num_tan, num_tan); % 用来得到每条路径发射探头和接收探头的位置

% x为发射探头的位置，在左侧，y为接收探头的位置，在右侧，建立射线方程y = k * x + b
[y, x] = find(D == 0); % 找到每条路径发射接收探头位置
k = (y - x) / (num_tan + 1); % 当坐标原点设在铝板左下角时，每条路径的斜率
b = x; % 每条路径的截距

% 把板宽129的板划分为128 * 128的网格
gr_unit = (num_tan + 1) / num_grid; % 每个网格宽度
gr = (0:gr_unit : num_tan + 1)'; % u为网格水平、垂直线

% 预设出路径的矩阵lujing
lujing = zeros(num_tan * num_tan, num_grid * num_grid);

%% 求出第i条射线在每个网格内的长度

for i = 1: length(x) % 逐条射线求解，共length(x)条射线

    % 求出射线和水平线的交点，为(u_row, v_row)
    if k(i) ~= 0 % 此时射线不是水平线，与水平网格有交点
        
        % 求出射线的纵坐标范围[v_row_min, v_row_max]
        v_row_min = b(i);
        v_row_max = (num_tan + 1) * k(i) + b(i);
        gr_row = gr(v_row_min <= gr & gr <= v_row_max); % gr_row为能与射线相交的水平线
        v_row = gr_row;
        u_row = (v_row - b(i)) / k(i);
        
    else % 射线为水平线，与水平网格无交点
        u_row = [];
        v_row = [];
    end
    
    % 求出射线和垂直线的交点（一定有），为(u_col, v_col)
    u_col = gr;
    v_col = k(i) .* u_col + b(i);
    
    % 射线和水平垂直线的所有交点坐标uv
    uv = [u_row, v_row; u_col, v_col];
    uv = sortrows(uv, 1); % 将uv按交点的横坐标排列
    uv = union(uv, uv, 'rows'); % 将计算出的交点中有重复的去掉
    
    % 求出射线上各段线段的长度
    L = sqrt(sum((uv(2: length(uv), :) - uv(1: length(uv) - 1, :)) .^ 2, 2)); % 坐标系上两点距离公式
    
    % 网格从左下开始，由下往上，由左到右编号，路径经过的网格编号为m,n
    m = ceil(roundn(uv(:, 1) / gr_unit, -4)); % ceil向 +inf 取整，roundn小数点后4位四舍五入
    m = max(m(1: end - 1), m(2: end)); % m为网格的列编号
    n = ceil(roundn(uv(:, 2) / gr_unit, -4));
    n = max(n(1: end - 1), n(2: end)); % m为网格的行编号
    
    % 将路径的值分配给各个经过的网格
    lujing_i = zeros(1, num_grid * num_grid);
    lujing_i(num_grid * (m - 1) + n) = L;

    lujing(i, :) = lujing_i;
end

lujing = 0.001 * a * lujing / (num_tan + 1); % 把路径换算成实际值

end
%{
画出第378条路径图像和路径矩阵的图像用来调试程序
% figure, imagesc(reshape(lujing(378, :), 128, 128)), colormap(gray), axis image
% figure, imagesc(lujing_28), colormap(gray)
% figure, imagesc(lujing), colormap(gray)
%}