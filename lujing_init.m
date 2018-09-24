%{
函数功能：在求出缺陷轮廓BW的基础上，将经过缺陷的路径缺陷之外的部分舍去，以修正sirt的算法造成的放射状赝像
引用函数：无
输入：边缘矩阵BW，路径矩阵lujing， 走时差和幅值差变化矩阵delta
输出：修正后的路径矩阵lujing_fil，修正后的走时差和幅值差变化矩阵delta
效果：路径的修正对sirt成像有效果，但是delta的修正看不出效果
%}

function [lujing_fil, delta] = lujing_init(BW, lujing, delta)

% 设和BW等大的矩阵unit
[x, y] = size(BW);
unit = zeros(x, y);

% i按列扫描，求出边缘矩阵存在1的列区域w1:w2
[~, w1] = find(any(BW), 1 ); % 找出BW存在1区域的最小列
[~, w2] = find(any(BW), 1, 'last' ); % 找出BW存在1区域的最大列
for i = w1: w2
    unit(find(BW(:, i), 1): find(BW(:, i), 1, 'last'), i) = 1;
end

% 将矩阵unit转化成列向量unit_l
unit_l = unit(:);

% 对路径矩阵进行窗口函数处理得到lujing
lujing_fil = zeros(size(lujing, 1), size(lujing, 2));
for i = 1: size(lujing, 1)
    ll = lujing(i, :)';
    ll(unit_l == 0) = 0;
    if any(ll) ~= 0; % 路径被缺陷约束完还存在不为0的值，说明该条路径经过了缺陷
        lujing_fil(i, :) = ll;
    else
        lujing_fil(i, :) = lujing(i, :);
%         delta(i) = 0; % 没有经过缺陷的走时差和幅值差就设为0
    end
end

%{
画出第378条路径图像和路径矩阵的图像用来调试程序
% figure, imagesc(reshape(lujing(378, :), 128, 128)), colormap(gray), axis image
% figure, imagesc(lujing_28), colormap(gray)
% figure, imagesc(lujing), colormap(gray)
%}

end