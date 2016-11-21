function NMRR =  f_DthAddDense(SourcePath, SketchPath, SketchName, ng)


global SHEETROW;
global EXCELPATH;
global SHEETNAME;

% 暂时不考虑
% FilePath = [];
% testType = 10;
% %测试集合i分别表示：蝴蝶，狗，帆船，盆景
% for j = 1:testType;
%     tempstr = num2str(i);
%     FilePath(i) = strcat('C:\\Users\\tinycat\\Desktop\\2014.7.12阈值测试\\测试', tempstr);
%     
%     FilePath(1) = dir(fullfile('C:\\Users\\tinycat\\Desktop\\2014.7.12阈值测试\\蝴蝶测试图片集\\*.jpg'));
% end


TempPath = strcat(SourcePath, '*.jpg');
Files = dir(fullfile(TempPath));
LengthFiles  = length(Files);
dis = zeros(1);


S = imread(SketchPath); % 手绘草图
thresh = graythresh(S);
S1 = im2bw(S,thresh); %带阈值的二值化 0是边缘点，1是非边缘点
S2 =~S1;    %1是边缘点，0是非边缘点
%e = find(S2==1);
%l = length(e);  %草图中边缘点的总个数
aa = 210;  %源图像大小
bb = 7;   %分块大小
S3=mat2cell(S2,ones(aa/bb,1)*bb,ones(aa/bb,1)*bb);%矩阵分块 300个10*10的子块

for num = 1:LengthFiles;
    path = strcat(SourcePath, Files(num).name);
    a = imread(path);
    
    %判断源图像是否为灰度图
    if ndims(a) == 3
        I = im2double(rgb2gray(a));
    else
        I = im2double(a);
    end    
    
    I1 = canny_edge(I,2.5);  %1是边缘点，0是非边缘点 调用canny_edge边缘检测函数
    e1 = find(I1==1);
    l1 = length(e1);
    %figure(2);
    %imshow(I1);
   
    I3=mat2cell(I1,ones(aa/bb,1)*bb,ones(aa/bb,1)*bb);
    C = zeros(bb);
    DD =[];
    LL =[];

    %去除图像矩阵中完全不包含边缘点的子块矩阵，即去除全部为1的矩阵
    for i = 1:aa/bb
        for j = 1:aa/bb          
            if I3{i,j}==C
                a=1;
            else
                a=0;
            if S3{i,j}==C
                b=1;
            else
                b=0;
            if a||b==1
                clear I3{i,j}
                clear S3{i,j}
            else
                [i,j];
            
            A = S3{i,j};  % 草图矩阵  1是边缘点，0是非边缘点
            B = I3{i,j};  % 数据库图像矩阵，距离变换的条件是    1是边缘点，0是非边缘点
            [r,c] = find (A==1); %在每个子块中边缘点所在的行列（在草图上的操作）
%---------------------------------------------------------------------------------------------          
           %在用length求矩阵长度的时候，若只有一行，最后计算的length的值也是2.这时候要改用以下代码。 
            % [r,c,v] = find (A==1); 
            % e =length(v);
%---------------------------------------------------------------------------------------------   
            [D,L]=bwdist(B);%D数据库图像距离变换图（在数据库图像矩阵B上的操作）
            D1=D(r,c); % 根据r，c的值得到一个r*c的矩阵，其中对角线上的数就是所求距离变换的值
            V = diag(D1,0); %根据草图中轮廓点的坐标得到的相应数据库图像上对应的距离变换
%-----------  添加阈值  ---------------------------------------------------------------------- 
            [m,n] = find(V<2.3);
            mn = [m,n];
            V1 = V(m,n);
            if isempty(V1)
                clear V1
            else 
                V2 = diag(V1,0);
%--------------------------------------------------------------------------------------------- 
            l2 =length(V2);
            d = mean(V2(:)); %求出每个子块距离变换后的平均值          
            DD = [DD d ]; %将每个子块的值存入矩阵DD
            LL = [LL l2];%所有参与计算的子块中边缘点的个数组成的矩阵
        
            end
            end
            end
            end
        end
    end
        DD;
        l3=sum(sum(LL)) ;   %所有参与计算的边缘点的个数
        Ratio = l3/l1;   %草图中参与计算的边缘点占源图像边缘点总数的比率
        dis(num) = 10*(1-Ratio)*mean(DD(:));
end

[dis_l,ind] = sort(dis);
imgName = {''};
NG = ng;
L = 2* NG;

for i=1:L
    %top_20(i)=ind(i); 
    if(rem(i-1,10)==0)
        disp('------------------');
    end
    disp(Files(ind(i)).name);

    imgName(i) = cellstr(Files(ind(i)).name);
end

% dispNum =16;
% row = 4;
% col = dispNum/row;
% for i =1:dispNum
%     path = strcat(SourcePath, Files(ind(i)).name);
%     x = imread(path);
%     subplot(row,col,i),imshow(x);
% end

avr = Avr(SketchName, imgName, NG);
MRR = avr-0.5-NG/2;
NMRR = MRR/(L+0.5-0.5*NG);

%ceil表示大于一个数的最小整数
row = ceil(L / 20);
imgRow = {''};
topRow = (0);
for i=0:row-1
    startRow = i*20+1;
    endRow = (i+1)*20;
    if (endRow>L)
        endRow = L;
    end
    k = 1;
    for j=startRow:endRow
        imgRow(k)=imgName(j);
        topRow(k)=dis_l(j);
        k =k + 1;
    end
    xlswrite(EXCELPATH, imgRow, SHEETNAME, strcat('A',num2str(SHEETROW)));
    SHEETROW = SHEETROW + 1;
    xlswrite(EXCELPATH, topRow, SHEETNAME, strcat('A',num2str(SHEETROW)));
    SHEETROW = SHEETROW + 2;
end

xlswrite(EXCELPATH, cellstr(strcat('AVR=',num2str(avr))), SHEETNAME, strcat('A',num2str(SHEETROW)));
SHEETROW = SHEETROW + 1;
xlswrite(EXCELPATH, cellstr(strcat('MRR=',num2str(MRR))), SHEETNAME, strcat('A',num2str(SHEETROW)));
SHEETROW = SHEETROW + 1;
xlswrite(EXCELPATH, cellstr(strcat('NMRR=',num2str(NMRR))), SHEETNAME, strcat('A',num2str(SHEETROW)));
SHEETROW = SHEETROW + 4;
disp(['AVR=',num2str(avr)]);
disp(['MRR=',num2str(MRR)]);
disp(['NMRR=',num2str(NMRR)]);
