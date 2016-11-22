package com.hust.response.impl;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.net.URLDecoder;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts2.ServletActionContext;
/*
 * 处理客户端请求显示在页面上检索出来的图片的响应
 */
public class ImageView {

	private BufferedImage image;
	private String info;

	public String excute() throws UnsupportedEncodingException {
		String[] paths = info.split("-");		
		URL url = getClass().getResource("/imgs/" + paths[0] + "/" + paths[1]);
		if (null == url) {
			url = getClass().getResource("/imgs/404.png");
		}
		String rootPath = URLDecoder.decode(url.getPath(),"utf-8");//设置编码格式
		File imgFile = new File(rootPath);
		HttpServletResponse response = null;
		ServletOutputStream out = null;
		FileInputStream fis = null;
        try {
            response = ServletActionContext.getResponse();//获得Response的对象
            out = response.getOutputStream();//获取一个向Response对象写入数据的流,当服务器进行响应的时候，会将Response中的数据写给浏览器
            fis = new FileInputStream(imgFile);
            int read = 0;
            byte[] buffer = new byte[1024];
            while ((read = fis.read(buffer)) != -1) {
				out.write(buffer, 0, read);
			}
            out.flush();
            fis.close();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
			if (null != out) {
				try {
					out.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
		return null;
	}
	
	public String getInfo() {
		return info;
	}

	public void setInfo(String info) {
		this.info = info;
	}

	public BufferedImage getImage() {
		return image;
	}

	public void setImage(BufferedImage image) {
		this.image = image;
	}
}
