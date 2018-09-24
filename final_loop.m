%{
�������ܣ�����ʱ������ж�ά����·����ֵ������������1d��2d��3dͼ�񣬶�ά���������������������
���ú�����fbpfilter.m��chengxiang_fb.m��filter2d.m��lujing_init.m��thickness.m
���룺��ʱ���ֵ�delta��·������lujing_28������A0ģʽ��ķ����Ƶ��f����ȱ�ݴ�����ĺ��d0
�����һά�˲��������ȱ��ͼ��һά�˲�����������ֵ���ȱ��ͼ�񣬺��2dͼ�����3dͼ;
      ��ά������Ϣ��ԭʼ��������ȡ��Ե�µĳ������double����Ե�ı�׼��BW_std������ϵ��BW_k����С��׼��BW_std_min
      ��ά�����Ϣ����������ĺ�Ⱦ���d1��ȱ�ݴ������ȵ�ƽ�����d1_mean����׼��d1_std
%}

function [BW_std, BW_k, BW_std_min, double, d1, d1_mean, d1_std] = final_loop(delta, lujing_28, f, d0)

S = zeros(size(lujing_28, 2), 1);

%��ԭʼ����delta����һά�˲�
delta_f = fbpfilter(delta);

% ��ȱ����sirt�����㷨���񣬵õ��������double
double = chengxiang_fb(lujing_28, delta_f, S);
    
% �Գ������double���Ե����BW�����Ը���filter2d����ı�ע����ά�˲����ͼ��
[BW, BW_std, BW_k, BW_std_min] = filter2d(double);

% ���ݱ�ԵBW�����һ�γ����lujing����
lujing = lujing_init(BW, lujing_28);

% ��������lujing�����ȱ����sirt�����㷨���񣬵õ��������double
double = chengxiang_fb(lujing, delta_f, S);

% ��ʾ�����ͼ��
[d1, d1_mean, d1_std] = thickness(double, BW, f, d0);

end