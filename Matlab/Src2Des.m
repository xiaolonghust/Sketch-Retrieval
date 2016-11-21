function Src2Des(srcPath, imageNum, desPath, testRoot, desWidth, desHeight, flag)

% ��������
% srcPath��Դ�ļ�·������srcPath = 'G:/test/srcPath/';
% desPath���������ݼ����ļ��ṹ��ԭ�ļ�һ�£�·������srcPath = 'G:/test/desPath/';
% testRoot���������ݼ���ͳһ��һ���ļ��У�Ŀ¼����srcPath = 'G:/test/testRoot/';
% ����Դ·���µ��ļ���������Ҫ���Ƶ�ͼƬ��
% ����־λflag=0ʱ�������ļ���Դ·�����ļ��ṹ����һ�£���Ϊ��ʱ�����ɵ�ͼƬ����ͬһ���ļ���testRoot��

%Դ·��
FileList = dir(fullfile(srcPath));
%Դ·���·����ļ��еĸ���
COUNT = size(FileList);

for i = 1:COUNT
    %Դ·���·����ļ���
    if(FileList(i).isdir&&~strcmp(FileList(i).name,'.')&&~strcmp(FileList(i).name,'..'))
        %���flag=0�����ɺ�Դ·�����ļ��ṹ����һ�£�����Դ·��������������µĲ��Լ��н����ļ����ļ���
        if (flag == 0)
            new_folder = strcat(desPath,FileList(i).name);
            mkdir(new_folder);
            new_folder = strcat(new_folder,'/');
        else
            new_folder = testRoot;
        end
        %Դ·����ÿһ��ͼƬ
        classPath = strcat(strcat(srcPath,FileList(i).name),'/');
        files = dir(fullfile(strcat(classPath,'*.jpg')));
        %ԭÿ����ͼƬ�ĸ���
        num = size(files);
        %���ԭ����ͼƬ������ָ����������ԭ���������㣬�������ָ�������Ĳ
        if (num < imageNum)
            disp(FileList(i).name,'����ͼƬ��������ָ����������ֵΪ��',num2str(imageNum - num));
            imageNum = num;
        end
        for j = 1:imageNum
            strcat(classPath,files(j).name);
            I = imread(strcat(classPath,files(j).name));           %����ÿ���ļ�
			I = imresize( I, [desWidth, desHeight] );%���µĹ�һ���ߴ��Դͼ��������ű任
            if(j<10)
                imwrite(I,strcat(strcat(strcat(strcat(new_folder,FileList(i).name),'-00'),num2str(j)),'.jpg'),'jpg');       %��ű���Ϊ��img_000X.jpg����img_0001.jpg
            elseif(j<100)
                imwrite(I,strcat(strcat(strcat(strcat(new_folder,FileList(i).name),'-0'),num2str(j)),'.jpg'),'jpg');       %��ű���Ϊ��img_00XX.jpg����img_0012.jpg
            else
                imwrite(I,strcat(strcat(strcat(strcat(new_folder,FileList(i).name),'-'),num2str(j)),'.jpg'),'jpg');       %��ű���Ϊ��img_0XXX.jpg����img_0123.jpg
            end
        end
    end
end

