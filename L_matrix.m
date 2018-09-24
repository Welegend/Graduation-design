% �������ܣ��������������������ȵȼ�಼��̽ͷ����SIRT������·������
% ���ú�������
% ���룺ÿ��̽ͷ����num_tan��������Сnum_grid��ÿ�ߣ���ʵ�ʰ��a (��λ����)
% �����SIRT������·������lujing��SIRT������ֵS

function lujing = L_matrix(num_tan, num_grid, a) % ���ｨģnum_tan + 1Ϊ���
%% �������߷���y = k * x + b����������

D = zeros(num_tan, num_tan); % �����õ�ÿ��·������̽ͷ�ͽ���̽ͷ��λ��

% xΪ����̽ͷ��λ�ã�����࣬yΪ����̽ͷ��λ�ã����Ҳ࣬�������߷���y = k * x + b
[y, x] = find(D == 0); % �ҵ�ÿ��·���������̽ͷλ��
k = (y - x) / (num_tan + 1); % ������ԭ�������������½�ʱ��ÿ��·����б��
b = x; % ÿ��·���Ľؾ�

% �Ѱ��129�İ廮��Ϊ128 * 128������
gr_unit = (num_tan + 1) / num_grid; % ÿ��������
gr = (0:gr_unit : num_tan + 1)'; % uΪ����ˮƽ����ֱ��

% Ԥ���·���ľ���lujing
lujing = zeros(num_tan * num_tan, num_grid * num_grid);

%% �����i��������ÿ�������ڵĳ���

for i = 1: length(x) % ����������⣬��length(x)������

    % ������ߺ�ˮƽ�ߵĽ��㣬Ϊ(u_row, v_row)
    if k(i) ~= 0 % ��ʱ���߲���ˮƽ�ߣ���ˮƽ�����н���
        
        % ������ߵ������귶Χ[v_row_min, v_row_max]
        v_row_min = b(i);
        v_row_max = (num_tan + 1) * k(i) + b(i);
        gr_row = gr(v_row_min <= gr & gr <= v_row_max); % gr_rowΪ���������ཻ��ˮƽ��
        v_row = gr_row;
        u_row = (v_row - b(i)) / k(i);
        
    else % ����Ϊˮƽ�ߣ���ˮƽ�����޽���
        u_row = [];
        v_row = [];
    end
    
    % ������ߺʹ�ֱ�ߵĽ��㣨һ���У���Ϊ(u_col, v_col)
    u_col = gr;
    v_col = k(i) .* u_col + b(i);
    
    % ���ߺ�ˮƽ��ֱ�ߵ����н�������uv
    uv = [u_row, v_row; u_col, v_col];
    uv = sortrows(uv, 1); % ��uv������ĺ���������
    uv = union(uv, uv, 'rows'); % ��������Ľ��������ظ���ȥ��
    
    % ��������ϸ����߶εĳ���
    L = sqrt(sum((uv(2: length(uv), :) - uv(1: length(uv) - 1, :)) .^ 2, 2)); % ����ϵ��������빫ʽ
    
    % ��������¿�ʼ���������ϣ������ұ�ţ�·��������������Ϊm,n
    m = ceil(roundn(uv(:, 1) / gr_unit, -4)); % ceil�� +inf ȡ����roundnС�����4λ��������
    m = max(m(1: end - 1), m(2: end)); % mΪ������б��
    n = ceil(roundn(uv(:, 2) / gr_unit, -4));
    n = max(n(1: end - 1), n(2: end)); % mΪ������б��
    
    % ��·����ֵ�������������������
    lujing_i = zeros(1, num_grid * num_grid);
    lujing_i(num_grid * (m - 1) + n) = L;

    lujing(i, :) = lujing_i;
end

lujing = 0.001 * a * lujing / (num_tan + 1); % ��·�������ʵ��ֵ

end
%{
������378��·��ͼ���·�������ͼ���������Գ���
% figure, imagesc(reshape(lujing(378, :), 128, 128)), colormap(gray), axis image
% figure, imagesc(lujing_28), colormap(gray)
% figure, imagesc(lujing), colormap(gray)
%}