package com.hust.util;

import java.awt.Image;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.IOException;

import javax.imageio.ImageIO;

import org.apache.commons.codec.binary.Base64;

public class ImgUtil {
	
	//图片归一化
	public static BufferedImage format(int width, int height,
			BufferedImage input) throws Exception {
		BufferedImage output = new BufferedImage(width, height,
				BufferedImage.TYPE_INT_RGB);
		Image image = input.getScaledInstance(output.getWidth(),
				output.getHeight(), output.getType());
		output.createGraphics().drawImage(image, null, null);
		return output;
	}
	
	//将客户端传过来的base64转换为图片
	public static BufferedImage getBitmap(String base64Str) {
		byte[] bs = Base64.decodeBase64(base64Str);
		for (int i = 0; i < bs.length; ++i) {
			if (bs[i] < 0) {// 调整异常数据
				bs[i] += 256;
			}
		}
		BufferedImage image = null;
		try {
			image = ImageIO.read(new ByteArrayInputStream(bs));
		} catch (IOException e) {
			System.out.println("Base64数据转图片失败");
		}
		return image;
	}
}
