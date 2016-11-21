function NMRR =  f_DthAddDense(SourcePath, SketchPath, SketchName, ng)


global SHEETROW;
global EXCELPATH;
global SHEETNAME;

% ��ʱ������
% FilePath = [];
% testType = 10;
% %���Լ���i�ֱ��ʾ�������������������辰
% for j = 1:testType;
%     tempstr = num2str(i);
%     FilePath(i) = strcat('C:\\Users\\tinycat\\Desktop\\2014.7.12��ֵ����\\����', tempstr);
%     
%     FilePath(1) = dir(fullfile('C:\\Users\\tinycat\\Desktop\\2014.7.12��ֵ����\\��������ͼƬ��\\*.jpg'));
% end


TempPath = strcat(SourcePath, '*.jpg');
Files = dir(fullfile(TempPath));
LengthFiles  = length(Files);
dis = zeros(1);


S = imread(SketchPath); % �ֻ��ͼ
thresh = graythresh(S);
S1 = im2bw(S,thresh); %����ֵ�Ķ�ֵ�� 0�Ǳ�Ե�㣬1�ǷǱ�Ե��
S2 =~S1;    %1�Ǳ�Ե�㣬0�ǷǱ�Ե��
%e = find(S2==1);
%l = length(e);  %��ͼ�б�Ե����ܸ���
aa = 210;  %Դͼ���С
bb = 7;   %�ֿ��С
S3=mat2cell(S2,ones(aa/bb,1)*bb,ones(aa/bb,1)*bb);%����ֿ� 300��10*10���ӿ�

for num = 1:LengthFiles;
    path = strcat(SourcePath, Files(num).name);
    a = imread(path);
    
    %�ж�Դͼ���Ƿ�Ϊ�Ҷ�ͼ
    if ndims(a) == 3
        I = im2double(rgb2gray(a));
    else
        I = im2double(a);
    end    
    
    I1 = canny_edge(I,2.5);  %1�Ǳ�Ե�㣬0�ǷǱ�Ե�� ����canny_edge��Ե��⺯��
    e1 = find(I1==1);
    l1 = length(e1);
    %figure(2);
    %imshow(I1);
   
    I3=mat2cell(I1,ones(aa/bb,1)*bb,ones(aa/bb,1)*bb);
    C = zeros(bb);
    DD =[];
    LL =[];

    %ȥ��ͼ���������ȫ��������Ե����ӿ���󣬼�ȥ��ȫ��Ϊ1�ľ���
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
            
            A = S3{i,j};  % ��ͼ����  1�Ǳ�Ե�㣬0�ǷǱ�Ե��
            B = I3{i,j};  % ���ݿ�ͼ����󣬾���任��������    1�Ǳ�Ե�㣬0�ǷǱ�Ե��
            [r,c] = find (A==1); %��ÿ���ӿ��б�Ե�����ڵ����У��ڲ�ͼ�ϵĲ�����
%---------------------------------------------------------------------------------------------          
           %����length����󳤶ȵ�ʱ����ֻ��һ�У��������length��ֵҲ��2.��ʱ��Ҫ�������´��롣 
            % [r,c,v] = find (A==1); 
            % e =length(v);
%---------------------------------------------------------------------------------------------   
            [D,L]=bwdist(B);%D���ݿ�ͼ�����任ͼ�������ݿ�ͼ�����B�ϵĲ�����
            D1=D(r,c); % ����r��c��ֵ�õ�һ��r*c�ľ������жԽ����ϵ��������������任��ֵ
            V = diag(D1,0); %���ݲ�ͼ�������������õ�����Ӧ���ݿ�ͼ���϶�Ӧ�ľ���任
%-----------  �����ֵ  ---------------------------------------------------------------------- 
            [m,n] = find(V<2.3);
            mn = [m,n];
            V1 = V(m,n);
            if isempty(V1)
                clear V1
            else 
                V2 = diag(V1,0);
%--------------------------------------------------------------------------------------------- 
            l2 =length(V2);
            d = mean(V2(:)); %���ÿ���ӿ����任���ƽ��ֵ          
            DD = [DD d ]; %��ÿ���ӿ��ֵ�������DD
            LL = [LL l2];%���в��������ӿ��б�Ե��ĸ�����ɵľ���
        
            end
            end
            end
            end
        end
    end
        DD;
        l3=sum(sum(LL)) ;   %���в������ı�Ե��ĸ���
        Ratio = l3/l1;   %��ͼ�в������ı�Ե��ռԴͼ���Ե�������ı���
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

%ceil��ʾ����һ��������С����
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
