package com.hust.util;

import java.awt.Color;
import java.awt.image.BufferedImage;
import java.io.IOException;

/**
 * 二值化的算法
 * 1、首先获取每个像素点的灰度值。灰度值= 红色亮度值*30%+绿色亮 度值*59%+蓝色亮度值*11%
 * 2、然后使用大津法获取图像的阀值。
 * 3、将一个像素点灰度值和它周围的8个灰度值相加再除以9，然后和阀值比较，大于阀值的则置为255，小于则是0。
 * @author 李小龙
 *
 */

public class ImageBinary {
	
	private static Integer[][] Matrix;
	
	public static Integer[][] getBinary(BufferedImage image) throws IOException{
		
		int width = image.getWidth();//获取图像的宽
		int height = image.getHeight();//获取图像的高 
		int area = width * height;//图像的面积
		int gray ;//图像的灰度值
		int[][] grayThreshold = new int [width][height];//求阈值时的灰度值
		int graysum = 0;//灰度值的和
		int graymean;//灰度值的平均值
		Matrix =new Integer[width][height];
		
		/*二维数组的行对应图像的高，二维数组的列对应图像的宽*/
		for (int x = 0; x < width; x++) {  
            for (int y = 0; y < height; y++) {  
                gray = getGray(image.getRGB(x, y));//每个坐标点的灰度  
                grayThreshold[x][y] = (gray<<16) + (gray<<8)+(gray);
                graysum += gray;
            }  
        }
		graymean = (int)(graysum/area);//整个图的灰度平均值 
		
		//使用大津法求阈值
		int graybackmean = 0;		
		int grayfrontmean = 0;
		int back = 0;
		int front = 0;
		for (int x = 0; x < width; x++) 
		{
			for (int y = 0; y < height; y++) {
				if (((grayThreshold[x][y]) & (0x0000ff)) < graymean) {
					graybackmean += ((grayThreshold[x][y]) & (0x0000ff));
					back++;
				} else {
					grayfrontmean += ((grayThreshold[x][y]) & (0x0000ff));
					front++;
				}
			}
		}
		int frontvalue = (int) (grayfrontmean / front);// 前景中心
		int backvalue = (int) (graybackmean / back);// 背景中心
		float G[] = new float[frontvalue - backvalue + 1];// 方差数组
		int s = 0;

		for (int i = backvalue; i < frontvalue + 1; i++)// 以前景中心和背景中心为区间采用大津法算法
		{
			back = 0;
			front = 0;
			grayfrontmean = 0;
			graybackmean = 0;
			for (int x = 0; x < width; x++) {
				for (int y = 0; y < height; y++) {
					if (((grayThreshold[x][y]) & (0x0000ff)) < (i + 1)) {
						graybackmean += ((grayThreshold[x][y]) & (0x0000ff));
						back++;
					} else {
						grayfrontmean += ((grayThreshold[x][y]) & (0x0000ff));
						front++;
					}
				}
			}
			grayfrontmean = (int) (grayfrontmean / front);
			graybackmean = (int) (graybackmean / back);
			G[s] = (((float) back / area) * (graybackmean - graymean)
					* (graybackmean - graymean) + ((float) front / area)
					* (grayfrontmean - graymean) * (grayfrontmean - graymean));
			s++;
		}
		float max = G[0];
		int index = 0;
		for (int j = 1; j < frontvalue - backvalue + 1; j++) {
			if (max < G[j]) {
				max = G[j];
				index = j;
			}
		}
		
		BufferedImage nbi=new BufferedImage(width,height,BufferedImage.TYPE_BYTE_BINARY);
		for (int x = 0; x < width; x++) {
			for (int y = 0; y < height; y++) {
				if((grayThreshold[x][y] & (0x0000ff))
						>(index + backvalue)){
					int maxrgb=new Color(255,255,255).getRGB();//白色,非边缘点
					//System.out.println("maxrgb= "+maxrgb);
					Matrix[x][y] = maxrgb;//=-1
					nbi.setRGB(x, y, maxrgb);
				}else{
					int minrgb=new Color(0,0,0).getRGB();//黑色，边缘点
					Matrix[x][y] = minrgb;//=-16777216
					nbi.setRGB(x, y, minrgb);
				}
			}
		}
		
		/*
		 * 使用M[y][x] = Matrix[x][y]
		 * 是由于二维数组(M)的行（第一维）对应图像的高，列（第二维）对应图像的宽,
		 * 将图像转换为像素数组(Matrix)时第一维对应图像的宽，第二维对应图像的高
		 */
		Integer[][] M = new Integer[width][height];
		for(int x=0;x<210;x++){
			for(int y=0;y<210;y++){
				if(Matrix[x][y]==-1){
					M[y][x] = Matrix[x][y]=0;
				}
				else{
					M[y][x] = Matrix[x][y]=1;
				}
			}
		}
				
		return M;
	}
	
	
	//自己加周围8个灰度值再除以9，算出其相对灰度值
	/*private int getAverageColor(int[][] gray, int x, int y, int width,
			int height) {
		int rs = gray[x][y]
              	+ (x == 0 ? 255 : gray[x - 1][y])
	            + (x == 0 || y == 0 ? 255 : gray[x - 1][y - 1])
	            + (x == 0 || y == height - 1 ? 255 : gray[x - 1][y + 1])
	            + (y == 0 ? 255 : gray[x][y - 1])
	            + (y == height - 1 ? 255 : gray[x][y + 1])
	            + (x == width - 1 ? 255 : gray[x + 1][ y])
	            + (x == width - 1 || y == 0 ? 255 : gray[x + 1][y - 1])
	            + (x == width - 1 || y == height - 1 ? 255 : gray[x + 1][y + 1]);
		return rs / 9;
	}*/
	
	//获取灰度值
	private static Integer getGray(int rgb) {
		Color c=new Color(rgb);  
        int r=c.getRed();//R空间  
        int g=c.getGreen();//G空间  
        int b=c.getBlue();//B空间  
        int grayValue=(int) (r*0.3+g*0.59+b*0.11);
		return (Integer)(grayValue);
	}
	
}

