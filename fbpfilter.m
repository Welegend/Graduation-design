% 函数功能：对一维的delta信号进行各种方式的滤波后，得到滤波后的一维列向量delta_f
% 引用函数：BWtest1d.m，Gaussianfilter1d.m
% 输入：走时和幅值变化量delta
% 输出：对每一个发射探头的投影进行滤波后的变化量delta_f

function delta_f = fbpfilter(delta)

% 将列向量原始delta信号变成方阵R_init
R_init = reshape(abs(delta), 28, 28);

% 对R_init的每一列都进行滤波处理，得到滤波后的方阵R
R = zeros(28, 28);
for j = 1: 28
    
    % 提取出R_init的第j个列向量ll
    ll = R_init(:, j);
    
    % 对列投影ll进行边界提取，然后进行分段滤波，这里滤波方法需要多次调整
    ww = BWtest1d(ll);
    w1 = ww(1);
    w2 = ww(2);
    w3 = ww(3);
    w4 = ww(4);
    ll(1: w1) = medfilt1(ll(1: w1), 10); % 中值滤波
    ll(1: w1) = smooth(ll(1: w1), 5, 'lowess'); % 滑动滤波
    ll(w4: 28) = medfilt1(ll(w4: 28), 10);
    ll(w4: 28) = smooth(ll(w4: 28), 5, 'lowess');
    ll(w2: w3) = medfilt1(ll(w2: w3), 5);
    ll(w2: w3) = Gaussianfilter1d(5, 0.3, ll(w2: w3)); % 事实上起到了放大了30%的作用而非滤波
    ll(w2: w3) = smooth(ll(w2: w3), 5, 'lowess');
    
    % 补偿缺陷边缘的走时幅值差，使其和理论更吻合
    ll(w1: w2) = ll(w1: w2) * 0.2;
    ll(w3: w4) = ll(w3: w4) * 0.2;
    
    % 补偿缺陷的走时差，使厚度更准确，用厚度修正这个参数
    ll = ll * 0.6;

    %把滤波后的ll的数据赋给R的第j列
    R(:, j) = ll;
end

%{
% 可尝试的滤波函数
%     R(:, j) = Gaussianfilter1d(3, 1, R_init(:, j));
%     R(:, j) = RLfilter(R_init(:, j));

%     A(:, i) = smooth(A(:, i), 30, 'lowess');
%     A(:, i) = smooth(A(:, i), 30, 'rlowess');
%     A(:, i) = smooth(A(:, i), 30, 'loess');
%     A(:, i) = smooth(A(:, i), 30, 'sgolay', 3);

%     A(:, i) = smoothts(A(:, i), 'e', 5);
%}

%{
% 进行边缘检测，舍去只检测到一个边缘的行与列，经验证没有效果
% T = ones(28, 28);
% for j = 1: 28
%     ww = BWtest1d(R(:, j));
%     if (ww(1) == ww(2) || ww(3) == ww(4))
%         T(:, j) = 0;
%     end
%     
%     ww = BWtest1d(R(j, :));
%     if (ww(1) == ww(2) || ww(3) == ww(4))
%         T(j, :) = 0;
%     end
% end
% R(T == 0) = 0;
%}

% 把经过滤波后的走时和幅值变化量R，变成列矩阵delta_f
delta_f = R(:);

% 观察滤波前后的第14个发射探头经过缺陷的变化图像
% figure, plot(1: 28, R_init(:, 14))
% figure, plot(1: 28, R(:, 14))

% clearvars -except double delta deltazoushi deltafuzhi delta_f lujing_28

end