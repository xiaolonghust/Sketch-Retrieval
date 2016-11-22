package com.hust.service;

import java.awt.image.BufferedImage;
import java.io.IOException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map.Entry;

import com.hust.util.ArrayUtil;
import com.hust.util.Constant;
import com.hust.util.ImageBinary;
/*
 * 草图矩阵和源图矩阵的比对，返回DIS按照升序排列的前二十个的图片的URL
 */
public class SketchService {
	
	private static int aa = Constant.AA;//源图像矩阵大小
	private static int bb = Constant.BB;//分块矩阵大小
	
	private static HashMap<String, Integer[][]> dataMap = DataToMemory.dataMap;//图片库中的图片经过处理后的<图片名称，二维数组>数据

	public static String[] getImgsBySketch(BufferedImage sketch) throws IOException {

		Integer[][] sketchMat = ImageBinary.getBinary(sketch);//草图进行二值化处理后的二维数组数据
		String[] imgs = getImgs(sketchMat);//草图和图片库中的图片的比对
		return imgs;
	}
	
	private static String[] getImgs(Integer[][] sketchMat) {
		
		Iterator<Entry<String, Integer[][]>> iter = dataMap.entrySet().iterator();
		Number[] dis = new Number[dataMap.size()];
		String[] name = new String[dataMap.size()];
		int count = 0;
		while (iter.hasNext()) {
			Entry<String, Integer[][]> entry = iter.next();
			name[count] = entry.getKey();
			dis[count] = getDis(sketchMat, entry.getValue());//平均检索率
			count++;
		}
		//排序并获得原来的序号
		int[] no = ArrayUtil.getSortNo(dis);
		String[] imgs = new String[Constant.MAX_IMGS];
		for (int i = 0; i < Constant.MAX_IMGS; i++) {
			imgs[i] = Constant.IMG_PREFIX + name[no[i]];
		}
		return imgs;
	}

	private static double getDis(Integer[][] sketchMat, Integer[][] imgMat) {
		//数组分块
		Integer[][][] sketchCell = mat2cell(sketchMat);
		Integer[][][] imgCell = mat2cell(imgMat);
		int point=0;
		//计算源图像中边缘点的个数point
		for (int i = 0; i < imgMat.length; i++) {
			for (int j = 0; j < imgMat.length; j++) {
				if (imgMat[i][j] == 1) {
					point++;
				}
			}
		}

		//草图与源图像的距离
		double dis = 0;
		//参与计算的子块的个数
		int count = 0;
		//参与计算边缘点的个数
		int pp = 0;
		for (int i=0; i<imgCell.length; i++) {
			//iCellFlag是标志源图此块是否可用于计算
			boolean iCellFlag = false;
			//sCellFlag是标志源图此块是否可用于计算
			boolean sCellFlag = false;
			for (int j=0; j<imgCell[i].length; j++) {
				for (int k=0; k<imgCell[i][j].length; k++) {
					if (imgCell[i][j][k] != 0) {
						iCellFlag = true;
					}
					if (sketchCell[i][j][k] != 0) {
						sCellFlag = true;
					}
				}
			}
			if (!(iCellFlag && sCellFlag)) {
				continue;//如果iCellFlag或sCellFlag为false，则停止执行当前的迭代，然后退回循环起始处，开始下一次迭代
			}

			//源图像cell距离变换图
			double[][] bwDist = getBwDist(imgCell[i]);

			//该cell距离小于阈值2.3的边缘点的个数
			int p = 0;
			//该cell的距离值
			double cellDis=0f;
			for (int j=0; j< bwDist.length; j++) {
				for (int k=0; k<bwDist[j].length; k++) {
					if (sketchCell[i][j][k] != 0 && bwDist[j][k] < 2.3) {
						cellDis += bwDist[j][k];
						p++;
					}
				}
			}
			if (p > 0) {
				dis += cellDis/p;
				count ++;
				pp += p;
			}
			
		}
		//10*(1-Ratio)*mean(DD(:))
		double ratio = (double)pp/point;//草图中参与计算的边缘点占源图像边缘点总数的比率
		return 10*(1-ratio)*(dis/count);
	}

	private static double[][] getBwDist(Integer[][] mat) {

	    if (mat.length == 0) {
	      return null;
	    }
	    
	    double[][] result = new double[mat.length][mat[0].length];
	    //用来计数mat中1的个数
	    int count = 0;
	    //r，c分别用来存储1的行列坐标位置
	    int[] r = new int[mat.length*mat[0].length];
	    int[] c = new int[mat.length*mat[0].length];
	    for (int i=0; i<mat.length; i++) {
	      for (int j=0; j<mat[i].length; j++) {
	        if (mat[i][j] == 1) {
	          r[count] = i;
	          c[count] = j;
	          count++;
	        }
	      }
	    }
	    for (int i=0; i<mat.length; i++) {
	      for (int j=0; j<mat[i].length; j++) {
	        //v用来存放距离变换后该位置的值
	        double v = -1f;
	        for (int k=0; k<count; k++) {
	          double temp = Math.sqrt(Math.pow(i-r[k], 2) + Math.pow(j-c[k], 2));
	          if (temp < v || v < 0f) {//获得每个位置距离变换后的最小值
	            v = temp;
	          }
	        }
	        result[i][j] = v;
	      }
	    }
	    return result;
	  }
	
	//数组分块
	private static Integer[][][] mat2cell(Integer[][] matrix) {
		Integer[][][] m = new Integer[(aa/bb)*(aa/bb)][bb][bb];
		for(int x = 0;x<aa;x++){
			for(int y = 0;y<aa;y++){
				m[(x/bb)*(aa/bb)+(y/bb)][x%bb][y%bb] = matrix[x][y];
			}
		}		
		return m;
	}
	
}
