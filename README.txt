方法一：分步进行
    第一步：导入deltazoushi，deltafuzhi，lujing_28，运行lilundelta_fb.m得到理论走时数据delta
    第二步：对deltazoushi，deltafuzhi进行一维投影滤波处理，运行fbpfilter.m对缺陷的放射投影进行滤波处理，其中引用了BWtest1d.m，Gaussianfilter1d.m的函数，得到滤波后的数据delta_f
    第三步：可以用projection绘制出1-28所有的放射投影图像，从而修正第二步的滤波效果
    第四步：用chengxiang_fb.m，对delta，deltazoushi，deltafuzhi，delta_f，lujing_28等数据求出慢度，并成像
    第五步：用filter2d.m对第四步的图像求二维的滤波图像，并对二维的缺陷图像求标准差std，补偿系数k_final，最小标准差z_min，其中用到了error_analysis.m的函数

方法二：直接运行final_loop.m即可