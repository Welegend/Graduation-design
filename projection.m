% �������ܣ�����ʵ���28��ͶӰ����ע����Ե����������ͶӰ����һ��
% ���ú�����BWtest1d.m
% ���룺ʵ����ʱ����������delta_f�����۵���ʱ������delta
% �����ÿһ������̽ͷ��ȱ�ݵ�ʵ�������ͶӰͼ�񣬲��üǺű�עʵ��ͼ��ı�Ե

clc
A = reshape(abs(deltazoushi), 28, 28);
B = reshape(abs(delta), 28, 28);

% �������ʱ��ֵ������ô������ã���ʾ��һ�������������ʱ��������β�����
A = mat2gray(abs(A));
B = mat2gray(abs(B));

for i=1:28
        ll = A(:, i);
        ww = BWtest1d(ll);
%         figure, plot(1: length(ll), ll, ww, ll(ww), 'ro') % �������۵���ʱB
        figure, plot(1: length(ll), ll, 1: length(ll), B(:, i), 'c--', ww, ll(ww), 'ro')
        
        % ������ʱ��ͼ����ʾ��ʽ
        xlim([1 28]);
%         ylim([0 1e-5]);
        set(gca, 'xtick', [1 5 10 15 20 25 28]);
end

% clearvars -except delta deltazoushi deltafuzhi delta_f lujing_14 lujing_28