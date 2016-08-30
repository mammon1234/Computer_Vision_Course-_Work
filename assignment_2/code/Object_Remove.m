img='test_im3.jpg';
WindowSize=11;
im = imread(img);
im = rgb2gray(im);
im( im==0 )=1;
result_img=im;

disp('Please draw the area of objects to be removed. Then double click it');
Remove_Region = roipoly(result_img);
unfilled_pixels=1-Remove_Region;
result_img=result_img.*uint8(unfilled_pixels);

temp_image=zeros(size(im,1),size(im,2));
MaxErrThreshold = 0.3;
figure
while 1
    progress = 0;
    if(min(min(result_img)) ~= 0) 
        break;
    end
    %pixel_list=GetUnfilledNeighbors(result_img,WindowSize);
    unfilled_image=result_img;
    unfilled_image(result_img<1) = 0 ;
    unfilled_image(result_img>=1) = 255;
    temp_unfilled_image=(imdilate(result_img,strel('square',3)))-unfilled_image;
    [row,col]=find(temp_unfilled_image>0);
    pixel=horzcat(row,col);
    padded_image = padarray(result_img,[(WindowSize-1)/2 (WindowSize-1)/2] );
    temp_pixel_1ist=[];
    for i=1 : size(pixel,1) ;
        n = nnz(double(padded_image( pixel(i,1) : (pixel(i,1)+WindowSize-1) , pixel(i,2) : (pixel(i,2)+WindowSize-1))));
        temp_pixel_1ist=[temp_pixel_1ist;n,pixel(i,:)];
    end
    pixel_list=sortrows(temp_pixel_1ist,-1);
    pixel_list=pixel_list(: , 2:3);

    for i=1:size(pixel_list,1);
        Row_Pixel_list=pixel_list(i,:);
        Neighbor_pixel=Row_Pixel_list-(WindowSize-1)/2;
        pad_area=zeros(WindowSize,WindowSize);
        padded_image = padarray(result_img,[(WindowSize-1)/2 (WindowSize-1)/2] );
        pad_area=double(padded_image( Neighbor_pixel(1,1)+(WindowSize-1)/2 : (Neighbor_pixel(1,1)+3*(WindowSize-1)/2) , Neighbor_pixel(1,2)+(WindowSize-1)/2 : (Neighbor_pixel(1,2)+3*(WindowSize-1)/2)) );
        
        pad_image2 = padarray(result_img,[35 35] );
        im_filled=double(pad_image2( Row_Pixel_list(1,1) : (Row_Pixel_list(1,1)+70) , Row_Pixel_list(1,2) : (Row_Pixel_list(1,2)+70)) );
        im_filled( :, ~any(im_filled,1) ) = [];
        im_filled( ~any(im_filled,2), : ) = [];  
        
        [Matches , error ]= FindMatch(pad_area, im_filled,WindowSize);
        r = floor(size(Matches,1).*rand(1,1) + 1);
        if (error(r) < MaxErrThreshold)
            if(temp_image(pixel_list(i,1),pixel_list(i,2))<7)
                result_img(pixel_list(i,1),pixel_list(i,2)) = Matches(r) ;
                progress = 1;
                if(Matches(r) == 0)
                    temp_image(pixel_list(i,1),pixel_list(i,2))=temp_image(pixel_list(i,1),pixel_list(i,2))+1;
                end    
            else
                temp_Neighbor_pixel=Row_Pixel_list-1;
                temp_pad_area=zeros(3,3);
                temp_padded_image = padarray(result_img,[1 1] );
                temp_pad_area=double(temp_padded_image( temp_Neighbor_pixel(1,1)+1 : (temp_Neighbor_pixel(1,1)+3) , temp_Neighbor_pixel(1,2)+1 : (temp_Neighbor_pixel(1,2)+3)) );
                result_img(pixel_list(i,1),pixel_list(i,2)) =sum(sum(temp_pad_area))/9;
            end
        end
    end
    if ( progress == 0 )
        MaxErrThreshold = MaxErrThreshold * 1.1 ;
    end
end
figure
imshow(result_img);