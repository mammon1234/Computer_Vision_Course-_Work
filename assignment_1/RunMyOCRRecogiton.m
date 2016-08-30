function [trainRateArray,totaltrainRate,testRate] =RunMyOCRRecogiton(filepath, locations, classes)
global Features;
global Labels;
Labels=[];
Features=[];
datapath= { 'a.bmp';'d.bmp'  ;'f.bmp' ;'h.bmp';
    'k.bmp' ; 'm.bmp' ;'n.bmp' ; 'o.bmp' ;
    'p.bmp' ;'q.bmp' ; 'r.bmp'  ;'s.bmp' ;
    'u.bmp'  ; 'w.bmp'  ;'x.bmp'  ;'z.bmp' } ;
for i=1:16;
    [Features, Labels]=OCR_Extract_Features(char(datapath(i)),i);
end

global Mean;
global Std;
Mean=mean(Features,1);
Std=std(Features,0,1);
global Normal_Features;
Normal_Features=[];
[m,n] = size(Features);
for i=1:m
    for j=1:n
        Normal_Features(i,j) = (Features(i,j) - Mean(j)) / Std(j);
    end
end

D=dist2(Normal_Features,Normal_Features);
[D_sorted, D_index]=sort(D,2);
figure
imagesc(D)
title('Training Distance Matrix')
%nearest_neighbour method to compute the accuracy of training data

%final_training = nearest_neighbour(D_index ,Labels , 4 ,2); 
%conf1=ConfusionMatrix(final_training,Labels,max(Labels));
%k=size(conf1);
%tem = 0;
%for j=1: k(1);
%    tem= tem+conf1(j,j);
%end
%tem = tem / k(1);
%disp('The efficiency or Recogntion Rate computed by system for training Images:');
%disp(tem);

TrainAns=[];
for i=1:size(D,1);
        TrainAns=[TrainAns;Labels(D_index(i,2))];
end
conf=ConfusionMatrix(Labels,TrainAns,16);
figure
imagesc(conf)
title('Training Confusion Matrix')

% Training recognition
trainRateArray=[];
totaltrainRate=0;
for i=1:15;
    [rate,count]=Training(char(datapath(i)),i,80);
    trainRateArray=[trainRateArray;rate];
    totaltrainRate=totaltrainRate+rate/16;
end
[rate, count]=Training(char(datapath(16)),16,83);
trainRateArray=[trainRateArray;rate];
totaltrainRate=totaltrainRate+rate/16;

[testRate,anss]=Test(filepath, locations, classes);
end