%{
% �������ܣ��ڵõ�·���������ʱ���ֵ�����֮����sirt�����㷨��ȱ�ݳ���һ�������S = 0
% ���ú�������
% ���룺·������lujing����ʱ���ֵ�������delta
% �����˫��׵����Ⱦ���double�����ɵĻҶ�ͼ
% �ĵã��������ٶȽ������������뵽��matlab��ѭ�������������㣻
       ���ǣ��ⲻ�Ǿ��Եģ��������������չ�˲���Ҫ��ά�ȣ�����˳�����󣬶������������һ��ѭ���ﷴ�����֣���ô�����������
       ���磬һ��������к�һ�����������ε�ˣ����Ϊ�˾������㣬�����������Ƴɷ�����ô���������
%}

function double = chengxiang_fb(lujing, delta)

%%%%%%%% ������sirt�����ȳ��� %%%%%%%%

% L��·������T����ʱ�����Ҫ��T = L * S�ķ�����
L = lujing;
T = abs(delta);

% Ԥ���sirt��ʽ��ı���
[m, n] = size(L); % m�����ߣ�n������
S = ones(n, 1) * 0; % sirt�㷨������������ֵͬ��������Ըı�0���������龭�鼴��ʼֵ
L_square = sum(L .^ 2, 2); % L����ÿ�е�ƽ��֮�ͣ��Ǹ���������������Ȩ��
N = sum(L ~= 0); % N��L�����в�Ϊ0�ĸ�������ÿ������ͨ��������������������ͶӰ
Wi = L ./ L_square(:, ones(1, n)) ./ N(ones(m, 1), :); % ���ÿ��ͶӰ�߶�ÿ������������Ȩ�أ�Ȼ��ͶӰ
delta_S = zeros(n, 1); % ���ȵ�����ֵ

k = 0; % ��������
fl = 1; % �������ȱ�־λ

% sirt����������
while (fl && k < 100)
    P = L * S; % �͹�ʽ���P������ͬ��ʵ�ʵ�ͶӰֵ
    delta_T = T - P; % ÿ��ͶӰ�ߵ�����
    
    % ���㱾�ε����������������ֵ
    for j = 1: n
        delta_S(j) = sum(delta_T .* Wi(:, j)); % ��ÿ��ͶӰ�ߵ�������Ȩƽ����Ȼ��ͶӰ
    end
    delta_S(isnan(delta_S)) = 0; % N����0Ԫ�أ������Ϊ�������NaN
    S = S + delta_S;
    
    % �ж��Ƿ��������������ֵ��С��1e-8
    if all(abs(delta_S) <= 1e-8)
        fl = 0;
    end
    
    % ����������һ
    k = k + 1;
end

% �õ�sirt�����������������mandu
mandu = S; % ���ﲻ�Ӿ���ֵ����deltazoushi�ϼ�
%% 
%%%%%%%%%% �����ǳ������ %%%%%%%%%%

num_grid = sqrt(size(lujing, 2)); % ������Сnum_grid��ÿ�ߣ�

% ��mandu���д����ɷ���˫��׾���double
single = reshape(mandu, num_grid, num_grid);
double = (single + rot90(single)) ./ 2;

% �򵥵���ֵ�˲�
double(abs(double) <= 0) = 0;

% ��double����ɻҶ�ͼ
figure, imagesc(double), colormap(gray), axis image

% xtick������Ҫ����Щֵ����ʾ�̶ȣ�xticklabel����ָ����ʾΪʲô  
set(gca, 'xtick', 0: 20: 128, 'xticklabel', 0: 50: 320, 'ytick', 8: 20: 128, 'yticklabel', 300: -50: 0);

% clearvars -except double delta deltazoushi deltafuzhi delta_f lujing_28 mandu

end
%{
������ͼ���
mesh(double);     % ����3Dͼ
surf(double,'EdgeColor','None');  % ����˫���ʱ��3Dͼ
contour(single,5)  % �ȸ���ͼ
shading interp;     % ͨ����ͬ������֮���ֵʹ������ͼ��ɫƽ��
%}