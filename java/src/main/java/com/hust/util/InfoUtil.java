package com.hust.util;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;

import javax.imageio.ImageIO;

import com.hust.util.CannyUtil;
import com.hust.util.ImgUtil;

import com.hust.util.Constant;

/**
 * 对图片库中的图片处理：
 * 1、归一化
 * 2、canny边缘提取得到一维数组
 * 3、将一维数组装换为二维矩阵
 */
public class InfoUtil {
	
	private static int width = Constant.WIDTH;//图像的宽
	private static int height = Constant.HEIGHT;//图像的高
	private static int aa = Constant.AA;//源图像矩阵大小

	public static Integer[][] getMatByFile(File filePath) {
		
		BufferedImage bi = null;
		//图像归一化，获得一个统一大小的图片
		try {
			bi = ImgUtil.format(width, height, ImageIO.read(filePath));
		} catch (IOException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
		Integer[][] imgMatrixs = getMatByImg(bi);//对图片处理得到图片的二维数组
		return imgMatrixs;
	}
	
	private static Integer[][] getMatByImg(BufferedImage bi) {
		int[] pix = CannyUtil.getCanny(bi);//canny边缘提取得到图片的一维数组
		int[][] SourceMatrix = new int[height][width];//源图像矩阵
		for(int i = 0;i<width*height;i++){
			SourceMatrix[i-(i/aa)*width][i/aa] = pix[i];//将一维数组转换为二维数组
		}
		
		/*Matrix=-1，白色，边缘点，设为1;Matrix=-16777216，黑色，非边缘点，设为0
		使用resultMatrix[y][x] = SourceMatrix[x][y]
		是由于二维数组(resultMatrix)的行（第一维）对应图像的高，列（第二维）对应图像的宽，
		将图像转换为像素数组(SourceMatrix)时第一维对应图像的宽，第二维对应图像的高*/
		Integer[][] resultMatrix = new Integer [height][width];
		for(int x=0;x<width;x++){
			for(int y=0;y<height;y++){
				if(SourceMatrix[x][y]==-1){
					resultMatrix[y][x] = 1;
				}
				else{
					resultMatrix[y][x] = 0;						
				}
			}
		}
		return resultMatrix;
	}

}
