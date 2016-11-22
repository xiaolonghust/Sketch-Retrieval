package com.hust.util;

public class Constant {

	public static String IMG_PREFIX = "http://172.27.35.4:8080/SketchRetrieval_Server/sketch/img.action?info=";	
	public static int WIDTH = 210;//图片的宽
	public static int HEIGHT = 210;//图片的高
	public static int AA = 210;//源图像矩阵大小
	public static int BB = 7;//分块矩阵大小	
	public static double THRESHOLD = 2.3;//距离变换的阈值
	public static int CANNY_THRESHOLD = 128;//canny边缘提取阈值
	public static int CANNY_WIDGAUSSIANKERNEL = 5;//边缘处理参数
	public static float SIAMA = 2.5F;//高斯滤波器参数,test:1.0F,1.5F,2.0F
	public static int NG = 10;//图片库中每类图片的个数
	public static int MAX_IMGS = 2*NG;//输出的图片的个数,为图片库中每类图片个数的两倍
}
