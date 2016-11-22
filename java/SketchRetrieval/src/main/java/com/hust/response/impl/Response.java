package com.hust.response.impl;

import java.awt.image.BufferedImage;
import java.io.IOException;

import com.hust.service.SketchService;
import com.hust.util.Constant;
import com.hust.util.ImgUtil;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/*
 * 1、将客户端传过来的base64转换为草图
 * 2、草图归一化
 * 3、草图的二值化以及和源图的比对，返回比对后效果最好的图片的URL地址
 * 4、将图片数据保存到JSON数组中
 */
public class Response {

	private JSONObject result = new JSONObject();
	private String info;
	
	public String excute() {
		BufferedImage sketch = ImgUtil.getBitmap(info);//将客户端传过来的base64转换为图片
		if (null == sketch) {
			result.put("status", 0);
			result.put("disc", "参数非法");
			return "success";
		}
		//草图进行归一化处理
		try {
			sketch = ImgUtil.format(Constant.WIDTH, Constant.HEIGHT, sketch);
		} catch (Exception e1) {
			System.out.println("草图归一化失败");
		}
		String[] imgs = null;
		try {
			imgs = SketchService.getImgsBySketch(sketch);//草图的二值化以及和源图的比对，返回比对后效果最好的图片的URL地址
		} catch (IOException e) {
			System.out.println("草图匹配结果失败");
		}
		if (null != imgs) {
			JSONArray array = JSONArray.fromObject(imgs);//将图片数据保存到JSON数组中
			result.put("status", 1);
			result.put("imgs", array);
		} else {
			result.put("status", 0);
		}
		return "success";
	}
	
	public JSONObject getResult() {
		return result;
	}

	public void setResult(JSONObject result) {
		this.result = result;
	}

	public String getInfo() {
		return info;
	}

	public void setInfo(String info) {
		this.info = info;
	}

}
