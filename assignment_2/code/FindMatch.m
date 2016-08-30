function [Matches,exceptions]= FindMatch(pad_area, Source_Img,WindowSize)
Matches=[];
exceptions=[];
pad_image = padarray(Source_Img,[(WindowSize-1)/2 (WindowSize-1)/2] );
%sum of squared differences
SSD=zeros(size(Source_Img,1),size(Source_Img,2));
ValidMask = pad_area;
ValidMask( ValidMask>0 )=1;
Sigma=size(pad_area,1)/6.4;
GaussMask =  fspecial('gaussian', size(pad_area,1), Sigma) ;
total_weight=  sum(sum(times(ValidMask , GaussMask)));

for i=1+(WindowSize-1)/2 : size(Source_Img,1)+(WindowSize-1)/2 ;
    for j=1+(WindowSize-1)/2 : size(Source_Img,2)+(WindowSize-1)/2;
        difference=(pad_area)-double((pad_image((i-(WindowSize-1)/2):(i+(WindowSize-1)/2) , (j-(WindowSize-1)/2) :(j+(WindowSize-1)/2)))) ;
        difference=difference.*difference;
        sum_difference=(difference.*ValidMask).*GaussMask;
        SSD(i-(WindowSize-1)/2,j-(WindowSize-1)/2)=((sum(sum(sum_difference)))/total_weight);
    end
end

temp_ssd=SSD;
temp_ssd(temp_ssd==0)=2000;
minimum = min(min(temp_ssd));
%use threshold to find the match parts
for i=1 : size(Source_Img,1) ;
    for j=1 : size(Source_Img,2) ;
        if ( (SSD(i,j) <= (minimum * 1.3)) )
            exceptions=[exceptions;(SSD(i,j)-abs(minimum * 1.3))];
            Matches=[Matches;Source_Img(i,j)];
        end
    end
end
return