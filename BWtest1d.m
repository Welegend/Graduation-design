% 函数功能：输入一个列向量l，对其进行fbp边缘检测并补偿，输出检测的边缘的位置向量ww
function ww = BWtest1d(ll)

% 归一化列向量
ll = mat2gray(ll);

% 求列向量的范围m，M
m = 1;
M = length(ll);

% 求l的导数l_diff，其绝对值l_diff_abs，找到其最大值和其位置w
l_diff = diff(ll);
l_diff_abs = abs(diff(ll));
w = find(l_diff_abs == max(l_diff_abs));

% 在最大增量w处往左往右找2个点，在这个区间内找最小值和最大值，和他们的位置w1，w2
[~, w1] = min(ll(max(w - 2, m): min(w + 3, M)));
[~, w2] = max(ll(max(w - 2, m): min(w + 3, M)));
w1 = w1 + max(w - 2, m) - 1;
w2 = w2 + max(w - 2, m) - 1;
if w1 > w2
    sw = w1;
    w1 = w2;
    w2 = sw;
    clear sw;
end

% 在找到一个边界的基础上，往左或右3个位置以外找另外一个边界的位置w0，其导数绝对值为d，fl为1时保留该位置
if (l_diff(w) > 0)
    [d, w0] = max(l_diff_abs(w2 + 3: M - 1));
    w0 = w0 + (w2 + 3) - 1;
    fl = (d > 0.15& l_diff(w0) < 0);
else
    [d, w0] = max(l_diff_abs(m: w1 - 4));
    fl = (d > 0.15& l_diff(w0) > 0);
end

% 在另外一边的最大增量w0处往左往右找3个点，在这个区间内找最小值和最大值，和他们的位置w3，w4
if (fl > 0)
    [~, w3] = min(ll(max(w0 - 3, m): min(w0 + 4, M)));
    [~, w4] = max(ll(max(w0 - 3, m): min(w0 + 4, M)));
    w3 = w3 + max(w0 - 3, m) - 1;
    w4 = w4 + max(w0 - 3, m) - 1;
else
    if l_diff(w) > 0
        w3 = M;
        w4 = M;
    else
        w3 = m;
        w4 = m;
    end
end

% 把w1、w2、w3、w4升序排列成ww
ww = sort([w1, w2, w3, w4]);
end