function Img = ExtensionImage(Img, Source_Img,WindowSize)
MaxErrThreshold = 0.3;
while 1
    if (min(min(Img)) ~= 0)
        break;
    end
    progress = 0;
    
    %find the Unfilled Pixel List
    temp_pixel_1ist=[];
    temp_Img=Img;
    temp_Img(Img>=1) = 255;
    temp_Img(Img<1) = 0 ;
    %find the edge of the current image
    temp_Img2=(imdilate(Img,strel('square',3)))-temp_Img;
    [row,col]=find(temp_Img2>0);
    pixel_img=horzcat(row,col);
    pad_img = padarray(Img,[(WindowSize-1)/2 (WindowSize-1)/2] );
    for i=1 : size(pixel_img,1) ;
        n=nnz(double(pad_img( pixel_img(i,1) : (pixel_img(i,1)+WindowSize-1),pixel_img(i,2):(pixel_img(i,2)+WindowSize-1))));
        temp_pixel_1ist=[temp_pixel_1ist;n,pixel_img(i,:)];
    end
    pixel_1ist=sortrows(temp_pixel_1ist,-1);
    pixel_1ist=pixel_1ist(: , 2:3);
    %End of find the Unfilled Pixel List
    
    for i=1:size(pixel_1ist,1);
        pixel = pixel_1ist(i,:);
        pixel = pixel - (WindowSize-1)/2;
        pad_area = zeros(WindowSize,WindowSize);
        temp_pad_area = padarray(Img,[(WindowSize-1)/2 (WindowSize-1)/2]);
        pad_area =double(temp_pad_area( pixel(1,1)+(WindowSize-1)/2 : pixel(1,1)+3*(WindowSize-1)/2 , pixel(1,2)+(WindowSize-1)/2: pixel(1,2)+3*(WindowSize-1)/2 )); 
        
        [Matches ,exceptions]= FindMatch(pad_area, Source_Img,WindowSize);
        Matches_R = size(Matches,1);
        while 1==1 ;
            r = floor((Matches_R -1).*rand(1,1) + 1);
            if (exceptions(r) < MaxErrThreshold)
                progress = 1;
                Img(pixel_1ist(i,1),pixel_1ist(i,2)) = Matches(r) ;
                break;
            end
        end
    end
    if ( progress == 0 )
        MaxErrThreshold = MaxErrThreshold * 1.1 ;
    end 
end

return