% �������ܣ���һά�źŵ�R-L�˲�
% ���ú�������
% ���룺R          :һά�ź�������
% �����R_filtered :һά�ź��˲���
% Ч��������ʵ�龫�����⣬�ô��˲����������ڳ���

function R_filtered = RLfilter(R)

% ��R��ÿһ�����������п��ٸ���Ҷ�任R_fft
width = size(R,1);
R_fft = fft(R,width);

% R-L�˲�����filter
filter = 2*[0:(width/2-1),width/2:-1:1]'/width;

% �˲���Ľ��R_fft_filtered
R_fft_filtered = R;
R_fft_filtered = R_fft .* filter;

% ����ٸ���Ҷ�任R_ifft
R_ifft = real(ifft(R_fft_filtered));

R_filtered = R_ifft;
