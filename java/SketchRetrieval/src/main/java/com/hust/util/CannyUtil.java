package com.hust.util;

import java.awt.Image;

import com.hust.canny.EdgeDetector;
import com.hust.canny.EdgeDetectorException;

public class CannyUtil {

	private static int[] pix;

	public static int[] getCanny(Image image) {

		EdgeDetector edgeDetector = new EdgeDetector();
		// 设置边缘处理的参数
		edgeDetector.setSourceImage(image); 
		edgeDetector.setThreshold(Constant.CANNY_THRESHOLD);
		edgeDetector.setWidGaussianKernel(Constant.CANNY_WIDGAUSSIANKERNEL);
		try {
			edgeDetector.process(); // 进行边缘处理
		} catch (EdgeDetectorException e) {
			System.out.println(e.getMessage());
		}
		pix = edgeDetector.getdata();

		return pix;
	}

}
