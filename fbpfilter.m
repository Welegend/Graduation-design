% �������ܣ���һά��delta�źŽ��и��ַ�ʽ���˲��󣬵õ��˲����һά������delta_f
% ���ú�����BWtest1d.m��Gaussianfilter1d.m
% ���룺��ʱ�ͷ�ֵ�仯��delta
% �������ÿһ������̽ͷ��ͶӰ�����˲���ı仯��delta_f

function delta_f = fbpfilter(delta)

% ��������ԭʼdelta�źű�ɷ���R_init
R_init = reshape(abs(delta), 28, 28);

% ��R_init��ÿһ�ж������˲������õ��˲���ķ���R
R = zeros(28, 28);
for j = 1: 28
    
    % ��ȡ��R_init�ĵ�j��������ll
    ll = R_init(:, j);
    
    % ����ͶӰll���б߽���ȡ��Ȼ����зֶ��˲��������˲�������Ҫ��ε���
    ww = BWtest1d(ll);
    w1 = ww(1);
    w2 = ww(2);
    w3 = ww(3);
    w4 = ww(4);
    ll(1: w1) = medfilt1(ll(1: w1), 10); % ��ֵ�˲�
    ll(1: w1) = smooth(ll(1: w1), 5, 'lowess'); % �����˲�
    ll(w4: 28) = medfilt1(ll(w4: 28), 10);
    ll(w4: 28) = smooth(ll(w4: 28), 5, 'lowess');
    ll(w2: w3) = medfilt1(ll(w2: w3), 5);
    ll(w2: w3) = Gaussianfilter1d(5, 0.3, ll(w2: w3)); % ��ʵ�����˷Ŵ���30%�����ö����˲�
    ll(w2: w3) = smooth(ll(w2: w3), 5, 'lowess');
    
    % ����ȱ�ݱ�Ե����ʱ��ֵ�ʹ������۸��Ǻ�
    ll(w1: w2) = ll(w1: w2) * 0.2;
    ll(w3: w4) = ll(w3: w4) * 0.2;
    
    % ����ȱ�ݵ���ʱ�ʹ��ȸ�׼ȷ���ú�������������
    ll = ll * 0.6;

    %���˲����ll�����ݸ���R�ĵ�j��
    R(:, j) = ll;
end

%{
% �ɳ��Ե��˲�����
%     R(:, j) = Gaussianfilter1d(3, 1, R_init(:, j));
%     R(:, j) = RLfilter(R_init(:, j));

%     A(:, i) = smooth(A(:, i), 30, 'lowess');
%     A(:, i) = smooth(A(:, i), 30, 'rlowess');
%     A(:, i) = smooth(A(:, i), 30, 'loess');
%     A(:, i) = smooth(A(:, i), 30, 'sgolay', 3);

%     A(:, i) = smoothts(A(:, i), 'e', 5);
%}

%{
% ���б�Ե��⣬��ȥֻ��⵽һ����Ե�������У�����֤û��Ч��
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

% �Ѿ����˲������ʱ�ͷ�ֵ�仯��R������о���delta_f
delta_f = R(:);

% �۲��˲�ǰ��ĵ�14������̽ͷ����ȱ�ݵı仯ͼ��
% figure, plot(1: 28, R_init(:, 14))
% figure, plot(1: 28, R(:, 14))

% clearvars -except double delta deltazoushi deltafuzhi delta_f lujing_28

end