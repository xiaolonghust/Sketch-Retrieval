    %function matlabcanny
  
       
       %I = imread('H:\测试图片\300混合搜索\birdge2.jpg');
       %I=rgb2gray(I);

       %BW = canny_edge(I,2.5); %调用canny_edge函数
       %figure(2)
      % imshow(BW)

% Canny边缘检测的函数
% Input:
%   a: input image  相当于I
%   sigma: Gaussian的均方差  相当于2.5
function e=canny_edge(a,sigma)

 a = double(a);     % 将图像像素数据转换为double类型
[m,n] = size(a);
e = repmat(logical(uint8(0)),m,n);  % 生成初始矩阵

OffGate = 0.0001;  
Perc = 0.7;
Th = 0.4;

pw = 1:30;             % hardcoding. But it's large enough if sigma isn't too large
sig2 = sigma * sigma;  % 方差

width = max(find(exp(-(pw.*pw)/(2*sig2)) > OffGate));  % 寻找截断点

t = (-width:width);
len = 2*width+1;
t3=[t-0.5;t;t+0.5];

dgau = (-t.*exp(-(t.*t)/(2*sig2))/sig2).';              % 一阶高斯函数的导数

ra = size(a,1);  % 图像行数
ca = size(a,2);  % 图像列数
ay = 255*a;
ax = 255*a';

ax = conv2(ax,dgau,'same').';   % 高斯平滑滤波后的图像的x方向梯度
ay = conv2(ay,dgau,'same');     % 高斯平滑滤波后的图像的y方向梯度
mag = sqrt((ax.*ax)+(ay.*ay));  % 每个像素点的梯度强度

magmax = max(mag(:));
if magmax>0
    mag = mag/magmax;  % 归一化
end
save result.mat mag

[counts,x] = imhist(mag,64);    % 直方图统计
high = min(find(cumsum(counts)>Perc*m*n))/64;
low = Th*high;

thresh = [low high];   % 根据直方图统计确定上下限
save result1.mat low
save result2.mat high

% Nonmax-suppression
idxStrong = [];
for dir = 1:4
    Localmax = Findlocalmax(dir,ax,ay,mag);
    idxWeak = Localmax(mag(Localmax)>low);
    e(idxWeak) = 1;
    idxStrong = [idxStrong; idxWeak(mag(idxWeak)>high)];
end

rstrong = rem(idxStrong-1,m)+1;
cstrong = floor((idxStrong-1)/m)+1;
e = bwselect(e,cstrong,rstrong,8);  %  
e = bwmorph(e,'thin',1);   % 使用形态学的方法把边缘变细


% 寻找最大值
function Localmax = Findlocalmax(direction,ix,iy,mag);

[m,n,o] = size(mag);

switch direction
    case 1
        idx = find((iy <= 0 & ix > -iy) | ( iy >= 0 & ix < -iy));
    case 2
        idx = find((ix > 0 & -iy >= ix) | ( ix < 0 & -iy <= ix));
    case 3
        idx = find((ix <= 0 & ix > iy) | ( ix >= 0 & ix < iy));
    case 4
        idx = find((iy < 0 & ix <= iy) | ( iy > 0 & ix >= iy));
end

if ~isempty(idx)
    v = mod(idx,m);
    extIdx = find(v==1|v==0|idx<=m|(idx>(n-1)*m));
    idx(extIdx)=[];
end

ixv = ix(idx);
iyv = iy(idx);
gradmag = mag(idx);
switch direction
    case 1
        d = abs(iyv./ixv);
        gradmag1 = mag(idx + m).*(1-d) + mag(idx + m - 1).*d;
        gradmag2 = mag(idx - m).*(1-d) + mag(idx - m + 1).*d;
    case 2
        d = abs(ixv./iyv);
        gradmag1 = mag(idx - 1).*(1-d) + mag(idx + m - 1).*d;
        gradmag2 = mag(idx + 1).*(1-d) + mag(idx - m + 1).*d;
    case 3
        d = abs(ixv./iyv);
        gradmag1 = mag(idx - 1).*(1-d) + mag(idx - m - 1).*d;
        gradmag2 = mag(idx + 1).*(1-d) + mag(idx + m + 1).*d;
    case 4
        d = abs(iyv./ixv);
        gradmag1 = mag(idx - m).*(1-d) + mag(idx - m - 1).*d;
        gradmag2 = mag(idx + m).*(1-d) + mag(idx + m + 1).*d;
end

Localmax = idx(gradmag >= gradmag1 & gradmag >= gradmag2 );
