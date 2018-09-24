% �������ܣ����������ȱ��ͼ�����ά���˲�ͼ�񣬲��Զ�ά��ȱ��ͼ�����׼��std������ϵ��k_final����С��׼��z_min
% ���ú�����error_analysis.m
% ���룺double�������
% �������׼��BW_std������ϵ��BW_k����С��׼��BW_std_min��ͼ��ı�Ե����BW

function [BW, BW_std, BW_k, BW_std_min] = filter2d(double)

% �ȹ�һ����Ȼ����٤������ͼ��������ȱ任͹�ԱȽ�������ֵ�󣩵Ĳ���
I = mat2gray(double);
I = imadjust(I, [], [], 3); %%%%% ���������Ҫ��ε���

% �򵥵���ֵ�˲��õ�I
I(I <= 0.1) = 0;

% ��ֵ�˲��õ�gs
gs = medfilt2(I, [15, 15]); %%%%% ���������Ҫ��ε���
gs = mat2gray(gs);


% ��ͼ����жԱȶȱ任�õ�g
E = 20;
m = 0.3;
g = 1 ./ (1 + (m ./ (gs + eps)) .^ E);

% �˴�����ϱ�Ե���õ�BW��С��ĳһֵ��ȱ�ݲ���⣨ʵ�龫�ȴﲻ����
[BW, ~] = edge(g, 'sobel');

% ����ͼ���˲�
% h = fspecial('gaussian');
% chengxiang = imfilter(I, h, 'replicate');


% ��ʾ�������˲������е�ͼ��
% figure, imagesc(I), colormap(gray), axis image % ٤�����任����ֵ�˲����ͼ��
% set(gca, 'xtick', 0: 20: 128, 'xticklabel', 0: 50: 320, 'ytick', [8: 20: 128], 'yticklabel', 300: -50: 0);
% figure, imagesc(gs), colormap(gray), axis image % ��ֵ�˲����ͼ��
% set(gca, 'xtick', 0: 20: 128, 'xticklabel', 0: 50: 320, 'ytick', [8: 20: 128], 'yticklabel', 300: -50: 0);
% figure, imagesc(g), colormap(gray), axis image % �Աȶȱ任���ͼ��
% set(gca, 'xtick', 0: 20: 128, 'xticklabel', 0: 50: 320, 'ytick', [8: 20: 128], 'yticklabel', 300: -50: 0);
figure, imagesc(BW), colormap(gray), axis image % ȱ�ݵı�Ե
set(gca, 'xtick', 0: 20: 128, 'xticklabel', 0: 50: 320, 'ytick', [8: 20: 128], 'yticklabel', 300: -50: 0);

% �����׼�����������ı�Եͼ��
[BW_std, BW_k, BW_std_min] = error_analysis(BW);

end