%{
�������ܣ������ȱ������BW�Ļ����ϣ�������ȱ�ݵ�·��ȱ��֮��Ĳ�����ȥ��������sirt���㷨��ɵķ���״����
���ú�������
���룺��Ե����BW��·������lujing�� ��ʱ��ͷ�ֵ��仯����delta
������������·������lujing_fil�����������ʱ��ͷ�ֵ��仯����delta
Ч����·����������sirt������Ч��������delta������������Ч��
%}

function [lujing_fil, delta] = lujing_init(BW, lujing, delta)

% ���BW�ȴ�ľ���unit
[x, y] = size(BW);
unit = zeros(x, y);

% i����ɨ�裬�����Ե�������1��������w1:w2
[~, w1] = find(any(BW), 1 ); % �ҳ�BW����1�������С��
[~, w2] = find(any(BW), 1, 'last' ); % �ҳ�BW����1����������
for i = w1: w2
    unit(find(BW(:, i), 1): find(BW(:, i), 1, 'last'), i) = 1;
end

% ������unitת����������unit_l
unit_l = unit(:);

% ��·��������д��ں�������õ�lujing
lujing_fil = zeros(size(lujing, 1), size(lujing, 2));
for i = 1: size(lujing, 1)
    ll = lujing(i, :)';
    ll(unit_l == 0) = 0;
    if any(ll) ~= 0; % ·����ȱ��Լ���껹���ڲ�Ϊ0��ֵ��˵������·��������ȱ��
        lujing_fil(i, :) = ll;
    else
        lujing_fil(i, :) = lujing(i, :);
%         delta(i) = 0; % û�о���ȱ�ݵ���ʱ��ͷ�ֵ�����Ϊ0
    end
end

%{
������378��·��ͼ���·�������ͼ���������Գ���
% figure, imagesc(reshape(lujing(378, :), 128, 128)), colormap(gray), axis image
% figure, imagesc(lujing_28), colormap(gray)
% figure, imagesc(lujing), colormap(gray)
%}

end