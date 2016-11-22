package com.hust.util;
/*
 * 对DIS按照升序排列，得到原来的序号
 */
public class ArrayUtil {

	public static int[] getSortNo(Number[] num){
		int[] result = new int[num.length];
		for (int i = 0; i < num.length; i++) {
			int position = i;
			Number min = num[i];
			for (int j = 0; j < num.length; j++) {
				if (min.doubleValue() > num[j].doubleValue()) {
					min = num[j];
					position = j;
				}
			}
			result[i] = position;
			num[position] = Double.MAX_VALUE;//将该值设为最大，不再参与计算
		}
		return result;
	}
	
	/*public static void main(String[] args) {
		Number[] a = {1.1, 2, 0.5, 2.5, 3, 1.1, 5};
		int[] p = getSortNo(a);
		for (int i = 0; i < p.length; i++) {
			System.out.print(p[i] + 1 + "\t");
		}
	}*/
}
