function result_img = Texture_Synthesis(img,WindowSize)
im=imread(img);
result_img = zeros(200,200);
result_row=100-floor(size(im,1)/2);
result_col=100-floor(size(im,2)/2);
im(im==0 )=1;
result_img(result_row+1:result_row+size(im,1),result_col+1:result_col+size(im,2))=im;
result_img=uint8(result_img);
%image extension
result_img=ExtensionImage(result_img, im, WindowSize);
%end of image extension
figure
imshow(result_img);
end