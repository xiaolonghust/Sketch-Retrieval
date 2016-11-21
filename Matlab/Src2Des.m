function Src2Des(srcPath, imageNum, desPath, testRoot, desWidth, desHeight, flag)

% 函数介绍
% srcPath是源文件路径，如srcPath = 'G:/test/srcPath/';
% desPath是生成数据集（文件结构与原文件一致）路径，如srcPath = 'G:/test/desPath/';
% testRoot是生成数据集（统一在一个文件夹）目录，如srcPath = 'G:/test/testRoot/';
% 利用源路径下的文件生成所需要名称的图片集
% 当标志位flag=0时，生成文件与源路径下文件结构保持一致，不为零时，生成的图片放在同一个文件夹testRoot下

%源路径
FileList = dir(fullfile(srcPath));
%源路径下分类文件夹的个数
COUNT = size(FileList);

for i = 1:COUNT
    %源路径下分类文件夹
    if(FileList(i).isdir&&~strcmp(FileList(i).name,'.')&&~strcmp(FileList(i).name,'..'))
        %如果flag=0，生成和源路径下文件结构保持一致，根据源路径下类的名称在新的测试集中建类文件夹文件夹
        if (flag == 0)
            new_folder = strcat(desPath,FileList(i).name);
            mkdir(new_folder);
            new_folder = strcat(new_folder,'/');
        else
            new_folder = testRoot;
        end
        %源路径下每一类图片
        classPath = strcat(strcat(srcPath,FileList(i).name),'/');
        files = dir(fullfile(strcat(classPath,'*.jpg')));
        %原每类中图片的个数
        num = size(files);
        %如果原来的图片不满足指定个数，则按原来个数计算，并输出与指定个数的差。
        if (num < imageNum)
            disp(FileList(i).name,'类中图片个数不够指定个数，差值为：',num2str(imageNum - num));
            imageNum = num;
        end
        for j = 1:imageNum
            strcat(classPath,files(j).name);
            I = imread(strcat(classPath,files(j).name));           %遍历每个文件
			I = imresize( I, [desWidth, desHeight] );%用新的归一化尺寸对源图像进行缩放变换
            if(j<10)
                imwrite(I,strcat(strcat(strcat(strcat(new_folder,FileList(i).name),'-00'),num2str(j)),'.jpg'),'jpg');       %序号保存为如img_000X.jpg，如img_0001.jpg
            elseif(j<100)
                imwrite(I,strcat(strcat(strcat(strcat(new_folder,FileList(i).name),'-0'),num2str(j)),'.jpg'),'jpg');       %序号保存为如img_00XX.jpg，如img_0012.jpg
            else
                imwrite(I,strcat(strcat(strcat(strcat(new_folder,FileList(i).name),'-'),num2str(j)),'.jpg'),'jpg');       %序号保存为如img_0XXX.jpg，如img_0123.jpg
            end
        end
    end
end

