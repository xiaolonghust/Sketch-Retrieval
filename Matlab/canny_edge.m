    %function matlabcanny
  
       
       %I = imread('H:\����ͼƬ\300�������\birdge2.jpg');
       %I=rgb2gray(I);

       %BW = canny_edge(I,2.5); %����canny_edge����
       %figure(2)
      % imshow(BW)

% Canny��Ե���ĺ���
% Input:
%   a: input image  �൱��I
%   sigma: Gaussian�ľ�����  �൱��2.5
function e=canny_edge(a,sigma)

 a = double(a);     % ��ͼ����������ת��Ϊdouble����
[m,n] = size(a);
e = repmat(logical(uint8(0)),m,n);  % ���ɳ�ʼ����

OffGate = 0.0001;  
Perc = 0.7;
Th = 0.4;

pw = 1:30;             % hardcoding. But it's large enough if sigma isn't too large
sig2 = sigma * sigma;  % ����

width = max(find(exp(-(pw.*pw)/(2*sig2)) > OffGate));  % Ѱ�ҽضϵ�

t = (-width:width);
len = 2*width+1;
t3=[t-0.5;t;t+0.5];

dgau = (-t.*exp(-(t.*t)/(2*sig2))/sig2).';              % һ�׸�˹�����ĵ���

ra = size(a,1);  % ͼ������
ca = size(a,2);  % ͼ������
ay = 255*a;
ax = 255*a';

ax = conv2(ax,dgau,'same').';   % ��˹ƽ���˲����ͼ���x�����ݶ�
ay = conv2(ay,dgau,'same');     % ��˹ƽ���˲����ͼ���y�����ݶ�
mag = sqrt((ax.*ax)+(ay.*ay));  % ÿ�����ص���ݶ�ǿ��

magmax = max(mag(:));
if magmax>0
    mag = mag/magmax;  % ��һ��
end
save result.mat mag

[counts,x] = imhist(mag,64);    % ֱ��ͼͳ��
high = min(find(cumsum(counts)>Perc*m*n))/64;
low = Th*high;

thresh = [low high];   % ����ֱ��ͼͳ��ȷ��������
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
e = bwmorph(e,'thin',1);   % ʹ����̬ѧ�ķ����ѱ�Ե��ϸ


% Ѱ�����ֵ
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
