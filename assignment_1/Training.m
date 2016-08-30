function [rate, count] = Training(fileName,class, num)
count = 0;
rate = 0;
im = imread(fileName);
%th=graythresh(im);
%th = th * 255;
th=215;
im2 = uint8(im < th);
L = bwlabel(im2);              

Numc = max(max(L));
TrainingFeatures = [];
location = [];
Bbox = [];

figure
imagesc(L)
hold on;
for i = 1:Numc;
    [r,c] = find(L == i);
    maxr = max(r);
    minr = min(r);
    maxc = max(c);
    minc = min(c);
    a = maxr-minr;
    b = maxc-minc;
    AreaThreshold = a*b;
    if (AreaThreshold >120)&&(a>7)&&(b>7)&&(b<120)&&(a<120)&&(a/b<5)&&(b/a<5)
        rectangle('position', [minc, minr, maxc - minc+1, maxr - minr+1], 'EdgeColor', 'w');
        Bbox = [Bbox; minc,maxc,minr,maxr];     
        location = [location; (minc+maxc)/2,(minr+maxr)/2];
        cim = im2(minr:maxr, minc:maxc);
        [centroid, theta, roundness, inmo] = moments(cim, 1);
        TrainingFeatures = [TrainingFeatures; theta,roundness,inmo];
    end  %if
end  %for
%hold off

%normalize test image features
global Mean;
global Std;

NorTrainingFeatures = [];
[m,n] = size(TrainingFeatures);

for i=1:m
    for j=1:n
        NorTrainingFeatures(i,j) = (TrainingFeatures(i,j) - Mean(j)) / Std(j);
    end
end
global Normal_Features;
DT = dist2(NorTrainingFeatures,Normal_Features);
[DT_sorted, DT_index] = sort(DT,2);       

global Labels;
for i=1:size(DT,1); 
    TrainingResult(i,1) = Labels(DT_index(i,2));
end
for i =1 : size(TrainingResult,1)
    text(Bbox(i,2),Bbox(i,4),int2str(TrainingResult(i,1)));
    text(location(i,1), location(i,2), int2str(class));
    if(TrainingResult(i,1) == class)
        count = count + 1;
    end        
end
hold off
rate = count / num;
end
