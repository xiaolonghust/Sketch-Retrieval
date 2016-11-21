clc
clear all
close all

global SHEETROW;
global EXCELPATH;
global SHEETNAME;

%----------------------------------------------------
% 1.测试数据及自动生成
% 标志位flag=0时，采用desPath路径，不为零时，采用testRoot路径
% 李小龙  2014-7-13
%----------------------------------------------------

%源路径
srcPath = 'F:/test/srcPath/Animal/30/';
%新的测试集的目录，与源路径下文件结构保持一致
desPath = 'C:/Users/tinycat/Desktop/测试数据集1/test/sketchPath/';
%生成的图片统一放在一个测试文件夹中
testRoot = 'F:/test/testRoot/2014-11-03/A10/';
%归一化图片宽度
desWidth = 210;
%归一化图片高度
desHeight = 210;
%需要图片的个数
NG = 10;
%标志位flag=0时，采用desPath路径，不为零时，采用testRoot路径
flag = 1;
%是否需要重建数据集，newDataSet=0表示不需要，newDataSet=1表示需要重建数据集
newDataSet = 0;
if(newDataSet == 1)
%     调用Src2Des函数生成所需要的图片
    Src2Des(srcPath, NG, desPath, testRoot, desWidth, desHeight, flag);
end


% ----------------------------------------------------
% 2.测试数据集图片归一化
% ----------------------------------------------------



% ----------------------------------------------------
% 3.对多类图片执行草图检索：每类图片仅使用一张草图
% 暂不包含草图归一化
% 结果输出到Excel
% 李小龙  2014-7-13
% ----------------------------------------------------

% 草图路径
sketchPath = 'F:/test/sketchPath/Animal/';

% 生成的Excel数据的路径

EXCELPATH = strcat(testRoot, '2014-11-03_210_7_Gauss.xlsx');   

%------------------------------------------------------------
%------------------------------------------------------------
EXCELPATH_result = 'F:/test/result/2014.11.03/2014-11-03_210_7_Gauss.xlsx';
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
SHEETROW_result = 26;                    
%------------------------------------------------------------
%------------------------------------------------------------

L = 2 * NG;
%测试集路径
disp(['当前测试集路径',testRoot]);
disp(['NG=',num2str(NG)]);
disp(['L=',num2str(L)]);

%草图源路径
FileList_sketch = dir(fullfile(sketchPath));
%草图源路径下分类文件夹的个数
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
        xlswrite(EXCELPATH, cellstr(strcat('当前测试集路径',testRoot)), SHEETNAME, strcat('A',num2str(SHEETROW)));
        SHEETROW = SHEETROW + 1;
        xlswrite(EXCELPATH, cellstr(strcat('NG=',num2str(NG))), SHEETNAME, strcat('A',num2str(SHEETROW)));
        SHEETROW = SHEETROW + 1;
        xlswrite(EXCELPATH, cellstr(strcat('L=',num2str(L))), SHEETNAME, strcat('A',num2str(SHEETROW)));
        SHEETROW = SHEETROW + 1;
        for j = 1:COUNT
            disp('--------------------------------------------------------------');
            disp(['当前检索-----',num2str(j)]);
            sketch = strcat(classPath,files(j).name);
%             n = strfind(files(j).name, '.');
%             sheetName = files(j).name(1:n-1);
           
            xlswrite(EXCELPATH, cellstr(strcat('当前用于检索的草图为：',sketch)), SHEETNAME, strcat('A',num2str(SHEETROW)));
            SHEETROW = SHEETROW + 1;
            %输出草图路径
            disp(['当前用于检索的草图为：',sketch]);
            %草图对测试集进行匹配
            
%------  仅DT ----  仅Dth  ---  DT+Dense  --- Dth+Dense  -----------    

            %NMRR = f_DT(testRoot, sketch, SHEETNAME, NG);  
            %NMRR = f_Dth(testRoot, sketch, SHEETNAME, NG);
%             NMRR = f_DTAddDense(testRoot, sketch, SHEETNAME, NG);
            NMRR = f_DthAddDense(testRoot, sketch, SHEETNAME, NG);
%             NMRR = f_DthAddDense_xl(testRoot, sketch, SHEETNAME, NG);
%             NMRR = f_DthAddDense_xl_holdOn(testRoot, sketch, SHEETNAME, NG);
            
%----------  添加距离概率  -------------------------------------------            
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