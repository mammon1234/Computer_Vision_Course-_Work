function [resultRate,detected_class] = Test(filename, location, classes)
im = imread(filename);
%th=graythresh(im);
%th = th * 255;
th=215;
im2 = uint8(im<th);
L = bwlabel(im2);              

Numc = max(max(L));
TestFeatures = [];
loc = [];
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
    if (AreaThreshold >150)&&(a>10)&&(b>10)&&(a/b<5)&&(b/a<5)
        rectangle('position', [minc, minr, maxc - minc+1, maxr - minr+1], 'EdgeColor', 'w');
        Bbox = [Bbox; minc,maxc,minr,maxr];
        loc = [loc; (minc+maxc)/2,(minr+maxr)/2];
        cim = im2(minr:maxr, minc:maxc);
        [centroid, theta, roundness, inmo] = moments(cim, 1);
        TestFeatures = [TestFeatures; theta, roundness, inmo];
    end  %if
end  %for


global Mean;
global Std;

NorTestFeatures = [];
[m,n] = size(TestFeatures);

for i=1:m
    for j=1:n
        NorTestFeatures(i,j) = (TestFeatures(i,j) - Mean(j)) / Std(j);
    end
end

%calculate dist2, sort
global Normal_Features;
DT = dist2(NorTestFeatures,Normal_Features);
[DT_sorted, DT_index] = sort(DT,2);       
global Labels
%nearest_neighbour
detected_class=nearest_neighbour(DT_index ,Labels ,4,1);

for i=1:size(DT,1); 
    TestResult(i,1) =  Labels(DT_index(i,2));
end

count = 0;
for i =1 : size(classes,1)
    text(location(i,1),location(i,2), int2str(classes(i,1)));
    %for j = 1 : size(TestResult,1)
    for j = 1 : size(detected_class,1)
        if (i == 1)
            %text(Bbox(j,2),Bbox(j,4),int2str(TestResult(j,1)));
            text(Bbox(j,2),Bbox(j,4),int2str(detected_class(j,1)));
        end
        if (Bbox(j,1)<location(i,1) && location(i,1)<Bbox(j,2) && Bbox(j,3)<location(i,2) && location(i,2)<Bbox(j,4))
            %if(TestResult(j,1) == classes(i,1))
            if(detected_class(j,1) == classes(i,1))
                count = count+1;
            end 
        end
    end
end

hold off
resultRate = count/ size(classes,1);

figure
imagesc(DT)
title('Testing Distance Matrix')
end
