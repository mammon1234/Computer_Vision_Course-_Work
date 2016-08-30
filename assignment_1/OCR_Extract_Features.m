function [ Features, Labels ] = OCR_Extract_Features( filepath, label)
global Features;
global Labels;
im=imread(filepath);
%th=graythresh(im);
%th = th * 255;
th=215;
im2=uint8(im<th);
L=bwlabel(im2);
Numc=max(max(L));
for i=1:Numc;
 [r,c]=find(L==i);
 maxr=max(r);
 minr=min(r);
 maxc=max(c);
 minc=min(c);
 a = maxr-minr;
 b = maxc-minc;
 AreaThreshold = a*b;
 if (AreaThreshold >120)&&(a>7)&&(b>7)&&(b<120)&&(a<120)&&(a/b<5)&&(b/a<5)
     cim = im2(minr:maxr,minc:maxc);
     [centroid, theta, roundness, inmo] = moments(cim, 1);
     Features=[Features;theta,roundness,inmo];
     Labels=[Labels; label];
 end
end
end
