function avr=Avr(sketch, imgName, NG) 
% disp('avr------------------imgname');
% imgName
%�õ���ͼ�ļ���
% n = strfind(sketch,'.jpg');
% ske = sketch(1:n-1);
totalRank = 0;
countmatch = 0;
L = 2*NG;
for i = 1:L
% 	�õ�ƥ��ͼ�ļ���
	img1 = char(imgName(i));
    m = strfind(img1,'-');
    img = img1(1:m-1);
%     disp(['ƥ��ͼ�ļ���----',img]);
% 	��ͼ��ƥ��ͼ�ļ����Ա�
	if(strcmp(sketch,img)==1)
		totalRank = totalRank + i;
        countmatch = countmatch + 1;
	end
end
avr =(totalRank + (NG-countmatch)*(L+1))/ NG;