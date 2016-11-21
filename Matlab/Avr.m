function avr=Avr(sketch, imgName, NG) 
% disp('avr------------------imgname');
% imgName
%得到草图文件名
% n = strfind(sketch,'.jpg');
% ske = sketch(1:n-1);
totalRank = 0;
countmatch = 0;
L = 2*NG;
for i = 1:L
% 	得到匹配图文件名
	img1 = char(imgName(i));
    m = strfind(img1,'-');
    img = img1(1:m-1);
%     disp(['匹配图文件名----',img]);
% 	草图和匹配图文件名对比
	if(strcmp(sketch,img)==1)
		totalRank = totalRank + i;
        countmatch = countmatch + 1;
	end
end
avr =(totalRank + (NG-countmatch)*(L+1))/ NG;