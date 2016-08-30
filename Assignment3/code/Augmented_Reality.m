clear all; close all;
% part 3 augmented realiity
load SavedParameter;
im1 = imread('images2.png');
im2 = imread('images9.png');
im3 = imread('images12.png');
im4 = imread('images20.png');
% augmenting image 9.jpg
im0 = imread('9.jpg');
im0 = rgb2gray(im0);
[M,N] = size(im0);
%set the scale as half of the grid image
d = 210/2/(M-1);
Pixel_scale = zeros(3,M*N);
Pixel = zeros(2,M*N);
for i = 1 : M
    for j = 1 : N
        Pixel(1,(i-1)*N+j) = j;
        Pixel(2,(i-1)*N+j) = i;
        Pixel_scale(1,(i-1)*N+j) = d*(j-1);
        Pixel_scale(2,(i-1)*N+j) = d*(i-1);
        Pixel_scale(3,(i-1)*N+j) = 1;

    end
end
figure;
for i = 1 : 4
    Img = eval(['im',int2str(i)]);
    Img = rgb2gray(Img);
    Pixel_2(:,:,i) = eval(['H',int2str(i),'_correct']) * Pixel_scale;
    Pixel_2(:,:,i) = Pixel_2(:,:,i)./[ Pixel_2(3,:,i); Pixel_2(3,:,i); Pixel_2(3,:,i)];
    Pixel_2(:,:,i) = uint16(Pixel_2(:,:,i));
    for j = 1 : N * M
        if (im0(M-Pixel(2,j)+1,Pixel(1,j)) ~= 255)
            Img( Pixel_2(2,j,i), Pixel_2(1,j,i)) = im0(M-Pixel(2,j)+1,Pixel(1,j));
        end
    end 
    Img = medfilt2(Img,[5 5]);
    subplot(2,2,i);
    imshow(Img(:,:)); 
    title('Figure4: Augmenting image ');
end
% augmenting a cube
Cube_original = [
      0 0 0 0  90 90 90 90;
      0 90 90 0 0 90 90 0;
      0 0 90 90 0 0 90 90;
      1 1 1 1 1 1 1 1];
Cube_projected = zeros(3,8,4);
figure;
for i = 1 : 4
    % compute and print 3D coordinates of the cube
    H_correct(:,:,i) = K_correct * [ eval(['R',int2str(i),'_newcorrect']), eval(['t',int2str(i),'_correct'])];
    Cube_projected(:,:,i) = H_correct(:,:,i) * Cube_original;
    Cube_projected(:,:,i) = Cube_projected(:,:,i)./[Cube_projected(3,:,i);Cube_projected(3,:,i);Cube_projected(3,:,i)];
    disp('3D coordinates of the cube in img')
    disp(Cube_projected(:,:,i))
    subplot(2,2,i); 
    imshow(eval(['im',int2str(i)])); 
    hold on;
    %synthesize new images with the virtual cube inserted
    plot([Cube_projected(1,1:4,i),Cube_projected(1,1,i)],[Cube_projected(2,1:4,i),Cube_projected(2,1,i)],'r-');
    plot([Cube_projected(1,5:8,i),Cube_projected(1,5,i)],[Cube_projected(2,5:8,i),Cube_projected(2,5,i)],'r-');
    plot([Cube_projected(1,1,i),Cube_projected(1,5,i)],[Cube_projected(2,1,i),Cube_projected(2,5,i)],'r-');
    plot([Cube_projected(1,2,i),Cube_projected(1,6,i)],[Cube_projected(2,2,i),Cube_projected(2,6,i)],'r-');
    plot([Cube_projected(1,3,i),Cube_projected(1,7,i)],[Cube_projected(2,3,i),Cube_projected(2,7,i)],'r-');
    plot([Cube_projected(1,4,i),Cube_projected(1,8,i)],[Cube_projected(2,4,i),Cube_projected(2,8,i)],'r-');
    title('Figure5: Augmenting cube');
end
