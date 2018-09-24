% 函数功能：对一维信号的R-L滤波
% 引用函数：无
% 输入：R          :一维信号列向量
% 输出：R_filtered :一维信号滤波后
% 效果：由于实验精度问题，用此滤波反而不利于成像

function R_filtered = RLfilter(R)

% 对R的每一个列向量进行快速傅里叶变换R_fft
width = size(R,1);
R_fft = fft(R,width);

% R-L滤波函数filter
filter = 2*[0:(width/2-1),width/2:-1:1]'/width;

% 滤波后的结果R_fft_filtered
R_fft_filtered = R;
R_fft_filtered = R_fft .* filter;

% 逆快速傅里叶变换R_ifft
R_ifft = real(ifft(R_fft_filtered));

R_filtered = R_ifft;
