function Result_Img = ExtensionImage2( Result_Img,WindowSize)
Img_temp=zeros(size(Result_Img,1),size(Result_Img,2));
MaxErrThreshold = 0.3;
while 1
    progress=0;
    if (min(min( Result_Img)) ~= 0)
        break;
    end
    
    temp_pixel_1ist=[];
    [row,col]=find(Result_Img==0);
    Unfilled_pixel=horzcat(row,col);
    padded_image = padarray(Result_Img,[(WindowSize-1)/2 (WindowSize-1)/2] );
    for i=1 : size(Unfilled_pixel,1) ;
        n = nnz(double(padded_image( Unfilled_pixel(i,1) : (Unfilled_pixel(i,1)+WindowSize-1) , Unfilled_pixel(i,2) : (Unfilled_pixel(i,2)+WindowSize-1)) ));
        if ( n ~= 0)
            temp_pixel_1ist=[temp_pixel_1ist;n,Unfilled_pixel(i,:)];
        end 
    end
    pixel_list=sortrows(temp_pixel_1ist,-1);
    pixel_list=pixel_list(: , 2:3);
    
    for i=1:size(pixel_list,1);
        pixel=pixel_list(i,:);
        %pad_area=GetNeighborhoodWindow(pixel,Result_Img,WindowSize);
        pixel_temp=pixel-(WindowSize-1)/2;
        pad_area=zeros(WindowSize,WindowSize);
        pad_image1 = padarray(Result_Img,[(WindowSize-1)/2 (WindowSize-1)/2] );
        pad_area=double(pad_image1( pixel_temp(1,1)+(WindowSize-1)/2 : (pixel_temp(1,1)+3*(WindowSize-1)/2) , pixel_temp(1,2)+(WindowSize-1)/2 : (pixel_temp(1,2)+3*(WindowSize-1)/2)) );
        
        pad_image2 = padarray(Result_Img,[35 35] );
        im_temp=double(pad_image2( pixel(1,1) : (pixel(1,1)+70) , pixel(1,2) : (pixel(1,2)+70)) );
        im_temp( :, ~any(im_temp,1) ) = [];
        im_temp( ~any(im_temp,2), : ) = [];
        
        [Matches , error]= FindMatch(pad_area, im_temp,WindowSize);
        Matches_R = size(Matches,1);
        if(size(error,1) ~= 0)
            while 1==1 ;
                r = floor(Matches_R .*rand(1,1) + 1);
                if ( (error(r) < MaxErrThreshold) )
                    if(Img_temp(pixel_list(i,1),pixel_list(i,2))<7)
                        Result_Img(pixel_list(i,1),pixel_list(i,2)) = Matches(r) ;
                        progress=1;
                        if(Matches(r) == 0)
                            Img_temp(pixel_list(i,1),pixel_list(i,2))=Img_temp(pixel_list(i,1),pixel_list(i,2))+1;
                        end  
                    else
                        temp_Neighbor_pixel=pixel-1;
						temp_pad_area=zeros(3,3);
						temp_padded_image = padarray(Result_Img,[1 1] );
						temp_pad_area=double(temp_padded_image( temp_Neighbor_pixel(1,1)+1 : (temp_Neighbor_pixel(1,1)+3) , temp_Neighbor_pixel(1,2)+1 : (temp_Neighbor_pixel(1,2)+3)) );
                        Result_Img(pixel_list(i,1),pixel_list(i,2)) =sum(sum(temp_pad_area))/9;
                    end
                    break;
                end
            end
        end
        if(progress==0)
            MaxErrThreshold=MaxErrThreshold*1.1;
        end
    end
end
return