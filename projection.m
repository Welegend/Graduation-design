% 函数功能：画出实验的28个投影，标注出边缘，并把理论投影画在一起
% 引用函数：BWtest1d.m
% 输入：实验走时数据列向量delta_f，理论的走时列向量delta
% 输出：每一个发射探头对缺陷的实验和理论投影图像，并用记号标注实验图像的边缘

clc
A = reshape(abs(deltazoushi), 28, 28);
B = reshape(abs(delta), 28, 28);

% 如果输入时幅值矩阵，那么这段启用，表示归一化，如果输入走时矩阵，则这段不启用
A = mat2gray(abs(A));
B = mat2gray(abs(B));

for i=1:28
        ll = A(:, i);
        ww = BWtest1d(ll);
%         figure, plot(1: length(ll), ll, ww, ll(ww), 'ro') % 不画理论的走时B
        figure, plot(1: length(ll), ll, 1: length(ll), B(:, i), 'c--', ww, ll(ww), 'ro')
        
        % 设置走时的图像显示格式
        xlim([1 28]);
%         ylim([0 1e-5]);
        set(gca, 'xtick', [1 5 10 15 20 25 28]);
end

% clearvars -except delta deltazoushi deltafuzhi delta_f lujing_14 lujing_28