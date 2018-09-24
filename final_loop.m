%{
函数功能：对走时矩阵进行二维成像，路径初值修正成像，求厚度1d、2d、3d图像，二维轮廓误差分析，厚度误差分析
引用函数：fbpfilter.m，chengxiang_fb.m，filter2d.m，lujing_init.m，thickness.m
输入：走时差（幅值差）delta，路径矩阵lujing_28，所用A0模式兰姆波的频率f，无缺陷处铝板的厚度d0
输出：一维滤波补偿后的缺陷图像，一维滤波数据修正初值后的缺陷图像，厚度2d图，厚度3d图;
      二维轮廓信息：原始数据在提取边缘下的成像矩阵double，边缘的标准差BW_std，补偿系数BW_k，最小标准差BW_std_min
      三维厚度信息：整个铝板的厚度矩阵d1，缺陷处铝板厚度的平均厚度d1_mean，标准差d1_std
%}

function [BW_std, BW_k, BW_std_min, double, d1, d1_mean, d1_std] = final_loop(delta, lujing_28, f, d0)

S = zeros(size(lujing_28, 2), 1);

%对原始数据delta进行一维滤波
delta_f = fbpfilter(delta);

% 对缺陷用sirt迭代算法成像，得到成像矩阵double
double = chengxiang_fb(lujing_28, delta_f, S);
    
% 对成像矩阵double求边缘矩阵BW，可以更改filter2d里面的备注看二维滤波后的图像
[BW, BW_std, BW_k, BW_std_min] = filter2d(double);

% 根据边缘BW求出下一次成像的lujing矩阵
lujing = lujing_init(BW, lujing_28);

% 用修正的lujing矩阵对缺陷用sirt迭代算法成像，得到成像矩阵double
double = chengxiang_fb(lujing, delta_f, S);

% 显示出厚度图像
[d1, d1_mean, d1_std] = thickness(double, BW, f, d0);

end