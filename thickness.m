% �������ܣ�A0ģʽ�µĲ���������ʱ������񣬰�mandu(double)����ת���ɺ�ȣ�������3dͼ
% ���ú�����S_init.m��h_analysis.m��fd_v_A0.mat��fd_v_S0.mat
% ���룺�������double����ȷ��ȡ��ȱ�ݱ�ԵBW������ķ������ģʽmode��1ΪA0��0ΪS0������ķ��Ƶ��f����λkHz������ȱ�ݴ��ĺ��d0����λmm��
% ���������ȱ�ݴ�����ĺ�����ߺ������ȵĶ�άͼ����άͼ����������ĺ�Ⱦ���d1��ȱ�ݴ������ȵ�ƽ�����d1_mean����׼��d1_std

function [d1, d1_mean, d1_std] = thickness(double, BW, mode, f, d0)

%%%%%%%%%% �ñ�Ե�Ժ��ͼ�����˲� %%%%%%%%%%

% ���Ѿ���ȷ��ȡ����ȱ�ݱ�Ե��ͼ����мӴ������˳�double�ڱ�Ե�����������������
% double(S_init(BW) == 0) = 0;

% ���Ѿ���ȷ��ȡ����ȱ�ݱ�Ե��ȱ���ڲ������˲�
% h = fspecial('average', [20 20]);
% double(S_init(BW) ~= 0) = imfilter(double(S_init(BW) ~= 0), h, 'replicate');

%%
%%%%%%%%%% A0��S0ģʽ�µ�Ƶ������ٶȹ�ϵ %%%%%%%%%%

load fd_v_A0.mat
load fd_v_S0.mat

if mode % ����ģʽ��A0
    fd = fd_v_A0(:, 1); %#ok<NODEF>
    v = fd_v_A0(:, 2);
else % ����ģʽ��S0
    fd = fd_v_S0(:, 1); %#ok<NODEF>
    v = fd_v_S0(:, 2);
end
%%
%%%%%%%%%% �ѳ������ double ֵ�����Ȳת��ΪA0��S0ģʽƵ��Ϊf�º��ֵ %%%%%%%%%%

% ��ȱ�ݴ��ĺ����d0����ķ����Ƶ��Ϊf����λkHz����Ӧ����ȱ�ݴ���Ⱥ�ٶ���v0
d0 = d0 * 1e-3; % �ѵ�λ��� m
[~, w] = min(abs(fd - f * d0));
v0 = v(w); % ��λ m/s

% v1Ϊ����ȱ�ݵ��ٶ�ֵ����d1Ϊ����ȱ�ݵ�������ֵ����
if mode % ģʽΪA0ģʽ
    v1 = 1 ./ (double + 1 / v0); % A0ģʽ��ķ������ȱ�ݱ���
else % ģʽΪS0ģʽ
    v1 = 1 ./ (1 / v0 - double); % S0ģʽ��ķ������ȱ�ݱ��
end
d1 = zeros(size(double, 1), size(double, 2));
for i = 1: numel(v1)
    if mode
        [~, w] = min(abs(v(1: 1617) - v1(i))); % ����A0Ⱥ�ٶ����߲���������������fd�ķ�ΧΪ��ֵ֮ǰ
    else
        [~, w] = min(abs(v(1: 1921) - v1(i))); % ����S0Ⱥ�ٶ����߲���������������fd�ķ�ΧΪ��ֵ֮ǰ
    end
    d1(i) = fd(w) / f * 1e3; % ��λmm
end
%%
%%%%%%%%%% �Ժ�Ⱦ����������ͳ�ƺ�ͼ����ʾ %%%%%%%%%%

% �����Ե��������ȱ�ݴ������ȵ�ƽ��ֵd1_mean����׼��d1_std
[d1_mean, d1_std] = h_analysis(BW, d1);

% ��������ĺ��1dͼ��2dͼ��3dͼ
% figure, plot(d1(63, :)); xlim([0 128]); ylim([0, 2.5]);
% set(gca, 'xtick', 0: 20: 128, 'xticklabel', 0: 50: 320, 'ytick', 0: 0.5: 2.5);
figure, imagesc(d1), colormap(gray), axis image
set(gca, 'xtick', 0: 20: 128, 'xticklabel', 0: 50: 320, 'ytick', 8: 20: 128, 'yticklabel', 300: -50: 0);
figure, mesh(d1), zlim([0, max(max(d1))])
set(gca, 'xtick', [0 128], 'xticklabel', [0 320], 'ytick', [0 128], 'yticklabel', [320 0]);

end