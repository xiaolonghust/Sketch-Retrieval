clc
clear all
close all

global SHEETROW;
global EXCELPATH;
global SHEETNAME;

%----------------------------------------------------
% 1.�������ݼ��Զ�����
% ��־λflag=0ʱ������desPath·������Ϊ��ʱ������testRoot·��
% ��С��  2014-7-13
%----------------------------------------------------

%Դ·��
srcPath = 'F:/test/srcPath/Animal/30/';
%�µĲ��Լ���Ŀ¼����Դ·�����ļ��ṹ����һ��
desPath = 'C:/Users/tinycat/Desktop/�������ݼ�1/test/sketchPath/';
%���ɵ�ͼƬͳһ����һ�������ļ�����
testRoot = 'F:/test/testRoot/2014-11-03/A10/';
%��һ��ͼƬ���
desWidth = 210;
%��һ��ͼƬ�߶�
desHeight = 210;
%��ҪͼƬ�ĸ���
NG = 10;
%��־λflag=0ʱ������desPath·������Ϊ��ʱ������testRoot·��
flag = 1;
%�Ƿ���Ҫ�ؽ����ݼ���newDataSet=0��ʾ����Ҫ��newDataSet=1��ʾ��Ҫ�ؽ����ݼ�
newDataSet = 0;
if(newDataSet == 1)
%     ����Src2Des������������Ҫ��ͼƬ
    Src2Des(srcPath, NG, desPath, testRoot, desWidth, desHeight, flag);
end


% ----------------------------------------------------
% 2.�������ݼ�ͼƬ��һ��
% ----------------------------------------------------



% ----------------------------------------------------
% 3.�Զ���ͼƬִ�в�ͼ������ÿ��ͼƬ��ʹ��һ�Ų�ͼ
% �ݲ�������ͼ��һ��
% ��������Excel
% ��С��  2014-7-13
% ----------------------------------------------------

% ��ͼ·��
sketchPath = 'F:/test/sketchPath/Animal/';

% ���ɵ�Excel���ݵ�·��

EXCELPATH = strcat(testRoot, '2014-11-03_210_7_Gauss.xlsx');   

%------------------------------------------------------------
%------------------------------------------------------------
EXCELPATH_result = 'F:/test/result/2014.11.03/2014-11-03_210_7_Gauss.xlsx';
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
SHEETROW_result = 26;                    
%------------------------------------------------------------
%------------------------------------------------------------

L = 2 * NG;
%���Լ�·��
disp(['��ǰ���Լ�·��',testRoot]);
disp(['NG=',num2str(NG)]);
disp(['L=',num2str(L)]);

%��ͼԴ·��
FileList_sketch = dir(fullfile(sketchPath));
%��ͼԴ·���·����ļ��еĸ���
dir_count = length(FileList_sketch);

ANMRR = 0;
class_count_sketch = 0;

for i=1:dir_count
    if(FileList_sketch(i).isdir&&~strcmp(FileList_sketch(i).name,'.')&&~strcmp(FileList_sketch(i).name,'..'))

        class_count_sketch = class_count_sketch + 1;
        classPath = strcat(strcat(sketchPath,FileList_sketch(i).name),'/');
        files = dir(fullfile(strcat(classPath,'*.jpg')));
        COUNT = length(files);
        NMRR_sum = 0;
        SHEETROW = 1;
        SHEETNAME = FileList_sketch(i).name;
        xlswrite(EXCELPATH, cellstr(strcat('��ǰ���Լ�·��',testRoot)), SHEETNAME, strcat('A',num2str(SHEETROW)));
        SHEETROW = SHEETROW + 1;
        xlswrite(EXCELPATH, cellstr(strcat('NG=',num2str(NG))), SHEETNAME, strcat('A',num2str(SHEETROW)));
        SHEETROW = SHEETROW + 1;
        xlswrite(EXCELPATH, cellstr(strcat('L=',num2str(L))), SHEETNAME, strcat('A',num2str(SHEETROW)));
        SHEETROW = SHEETROW + 1;
        for j = 1:COUNT
            disp('--------------------------------------------------------------');
            disp(['��ǰ����-----',num2str(j)]);
            sketch = strcat(classPath,files(j).name);
%             n = strfind(files(j).name, '.');
%             sheetName = files(j).name(1:n-1);
           
            xlswrite(EXCELPATH, cellstr(strcat('��ǰ���ڼ����Ĳ�ͼΪ��',sketch)), SHEETNAME, strcat('A',num2str(SHEETROW)));
            SHEETROW = SHEETROW + 1;
            %�����ͼ·��
            disp(['��ǰ���ڼ����Ĳ�ͼΪ��',sketch]);
            %��ͼ�Բ��Լ�����ƥ��
            
%------  ��DT ----  ��Dth  ---  DT+Dense  --- Dth+Dense  -----------    

            %NMRR = f_DT(testRoot, sketch, SHEETNAME, NG);  
            %NMRR = f_Dth(testRoot, sketch, SHEETNAME, NG);
%             NMRR = f_DTAddDense(testRoot, sketch, SHEETNAME, NG);
            NMRR = f_DthAddDense(testRoot, sketch, SHEETNAME, NG);
%             NMRR = f_DthAddDense_xl(testRoot, sketch, SHEETNAME, NG);
%             NMRR = f_DthAddDense_xl_holdOn(testRoot, sketch, SHEETNAME, NG);
            
%----------  ��Ӿ������  -------------------------------------------            
            %NMRR = f_DtAddDisProAddpixPro(testRoot, sketch, SHEETNAME, NG);
            %NMRR = f_DthAddDisPro(testRoot, sketch, SHEETNAME, NG);
%---------------------------------------------------------------------
            
            NMRR_sum = NMRR_sum + NMRR;
            
        end
        
        %------------------------------------------------------------
        NMRR_V(class_count_sketch) = NMRR_sum;
        %!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        xlswrite(EXCELPATH_result, cellstr('210--7*7'), 'result', strcat('A',num2str(SHEETROW_result)));
        %!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        xlswrite(EXCELPATH_result, cellstr('Dth2.3'), 'result', strcat('B',num2str(SHEETROW_result)));
        xlswrite(EXCELPATH_result, NMRR_V, 'result', strcat('C',num2str(SHEETROW_result)));
        
        %------------------------------------------------------------
        
        xlswrite(EXCELPATH, cellstr(strcat('NMRR_sum=',num2str(NMRR_sum))), SHEETNAME, strcat('A',num2str(SHEETROW)));
        SHEETROW = SHEETROW + 1;
        ANMRR = ANMRR + NMRR_sum;
    end
    
end

ANMRR = ANMRR / class_count_sketch;
xlswrite(EXCELPATH, cellstr(strcat('ANMRR=',num2str(ANMRR))), SHEETNAME, strcat('A',num2str(SHEETROW)));

%------------------------------------------------------------
xlswrite(EXCELPATH_result, ANMRR, 'result', strcat('L',num2str(SHEETROW_result)));       
%------------------------------------------------------------