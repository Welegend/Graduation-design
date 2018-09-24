% �������ܣ�����һ��������l���������fbp��Ե��Ⲣ������������ı�Ե��λ������ww
function ww = BWtest1d(ll)

% ��һ��������
ll = mat2gray(ll);

% ���������ķ�Χm��M
m = 1;
M = length(ll);

% ��l�ĵ���l_diff�������ֵl_diff_abs���ҵ������ֵ����λ��w
l_diff = diff(ll);
l_diff_abs = abs(diff(ll));
w = find(l_diff_abs == max(l_diff_abs));

% ���������w������������2���㣬���������������Сֵ�����ֵ�������ǵ�λ��w1��w2
[~, w1] = min(ll(max(w - 2, m): min(w + 3, M)));
[~, w2] = max(ll(max(w - 2, m): min(w + 3, M)));
w1 = w1 + max(w - 2, m) - 1;
w2 = w2 + max(w - 2, m) - 1;
if w1 > w2
    sw = w1;
    w1 = w2;
    w2 = sw;
    clear sw;
end

% ���ҵ�һ���߽�Ļ����ϣ��������3��λ������������һ���߽��λ��w0���䵼������ֵΪd��flΪ1ʱ������λ��
if (l_diff(w) > 0)
    [d, w0] = max(l_diff_abs(w2 + 3: M - 1));
    w0 = w0 + (w2 + 3) - 1;
    fl = (d > 0.15& l_diff(w0) < 0);
else
    [d, w0] = max(l_diff_abs(m: w1 - 4));
    fl = (d > 0.15& l_diff(w0) > 0);
end

% ������һ�ߵ��������w0������������3���㣬���������������Сֵ�����ֵ�������ǵ�λ��w3��w4
if (fl > 0)
    [~, w3] = min(ll(max(w0 - 3, m): min(w0 + 4, M)));
    [~, w4] = max(ll(max(w0 - 3, m): min(w0 + 4, M)));
    w3 = w3 + max(w0 - 3, m) - 1;
    w4 = w4 + max(w0 - 3, m) - 1;
else
    if l_diff(w) > 0
        w3 = M;
        w4 = M;
    else
        w3 = m;
        w4 = m;
    end
end

% ��w1��w2��w3��w4�������г�ww
ww = sort([w1, w2, w3, w4]);
end