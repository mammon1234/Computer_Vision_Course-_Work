function result_img=Image_Inpainting(Img,WindowSize)
im = imread(Img);
result_img=im;
%figure
%imshow(result_img);
result_img= ExtensionImage2(result_img,WindowSize);
figure
imshow(result_img);
return