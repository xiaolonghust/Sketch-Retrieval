package com.hust.service;

import java.io.File;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.HashMap;

import com.hust.util.InfoUtil;

/*
 * 将图片库中的图片经过canny边缘提取处理得到二维矩阵放在内存中
 */
public class DataToMemory {

	public static HashMap<String, Integer[][]> dataMap = new HashMap<String, Integer[][]>();

	public void execute() throws UnsupportedEncodingException {
		//在java中获取文件路径的时候，有时候会获取到空格，但是在中文编码环境下，空格会变成"%20"从而使得路径错误
		String rootPath = URLDecoder.decode(this.getClass().getResource("/imgs").getPath(),"utf-8");
		File root = new File(rootPath);
		//System.out.println("图片路径:" + rootPath);
		if (!root.exists()) {
			System.out.println(root);
			System.out.println("root is not exist");
			return;
		}
		if (root.isFile()) {
			System.out.println("root is not folder");
			return;
		}
		File[] files = root.listFiles();
		for (File file : files) {
			if (file.isDirectory()) {
				String fileName = file.getName();//图片文件夹的名称
				//System.out.println(fileName);
				File[] itemFiles = file.listFiles();
				for (File item : itemFiles) {
					Integer[][] mat = InfoUtil.getMatByFile(item);//canny边缘提取
					String key = fileName + "-" + item.getName();//一类图片文件夹的名称+图片的名称
					dataMap.put(key, mat);
				}
			}
		}
	}
}
