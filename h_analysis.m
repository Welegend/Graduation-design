% �������ܣ������ȱ�����Ϊ1mm����ʵ����ȱ�ݴ���������ƽ�����d1_mean����׼��d1_std
% ���ú�������
% ���룺BW��������ͺ��ͼ
% �����ȱ�ݴ������ȵ�ƽ�����d1_mean����׼��d1_std

function [d1_mean, d1_std] = h_analysis(BW, d1)

% ���BW�ȴ�ľ���mandu
[x, y] = size(BW);
mandu = zeros(x, y);

% i����ɨ�裬�����Ե�������1��������w1:w2
[~, w1] = find(any(BW), 1 ); % �ҳ�BW����1�������С��
[~, w2] = find(any(BW), 1, 'last' ); % �ҳ�BW����1����������
for i = w1: w2
    mandu(find(BW(:, i), 1): find(BW(:, i), 1, 'last'), i) = 1;
end

% ȱ���ڲ���ȵ�ƽ��ֵ�������ȵı�׼��
d1 = d1(mandu == 1);
d1_mean = mean(d1(:));
d1_std = sqrt(mean((d1(:) - 1) .^ 2));

end