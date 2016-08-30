% compute the 3d coordinates of 4 corners of grid
x0 = [0 0 270 270; 
    0 210 210 0; 
    1 1 1 1];
% Compute and Print homography H of images2
im1 = imread('images2.png');
figure
imshow(im1);
[rows, columns] = ginput(4);
x1= [rows.'; columns.'; ones(1,4)];
H1 = homography2d(x0,x1);
disp('homography H of images2')
disp(H1)

% Compute and Print homography H of images9
im2 = imread('images9.png');
figure
imshow(im2);
[rows, columns] = ginput(4);
x2= [rows.'; columns.'; ones(1,4)];
H2 = homography2d(x0,x2);
disp('homography H of images9')
disp(H2)

% Compute and Print homography H of images12
im3 = imread('images12.png');
figure
imshow(im3);
[rows, columns] = ginput(4);
x3= [rows.'; columns.'; ones(1,4)];
H3 = homography2d(x0,x3);
disp('homography H of images12')
disp(H3)

% Compute and Print homography H of images20
im4 = imread('images20.png');
figure
imshow(im4);
[rows, columns] = ginput(4);
x4= [rows.'; columns.'; ones(1,4)];
H4 = homography2d(x0,x4);
disp('homography H of images20')
disp(H4)
% Computing the Intrinsic and Extrinsic parameters
 [K,t1,t2,t3,t4,R1_new,R2_new,R3_new,R4_new] = compute_parameter(H1,H2,H3,H4);

%Improving accuracy
%compute and print approximate corners
X_appro = zeros(3,80);
X_appro(3,:) = ones(1,80);
for i = 1 : 8
    for j = 1 : 10
        X_appro(1,(i-1)*10+j) = 30*(j-1);
        X_appro(2,(i-1)*10+j) = 30*(i-1);
    end
end
figure; 
for i = 1 : 4
    p_approx(:,:,i) = eval(['H',int2str(i)]) *  X_appro;
    p_approx(:,:,i) = p_approx(:,:,i)./[p_approx(3,:,i);p_approx(3,:,i);p_approx(3,:,i)];
    subplot(2,2,i); 
    imshow(eval(['im',int2str(i)])); 
    hold on;
    plot(p_approx(1,:,i),p_approx(2,:,i),'ro');
    title('Figure1: Projected grid corners');
end
%compute and print Harris corners and grid corners
for i = 1 : 4     
    [cim, r, c, rsubp, csubp] = harris(rgb2gray(eval(['im',int2str(i)])), 2, 500, 2, 0);
    figure;
    subplot(1,2,1);
    imshow(eval(['im',int2str(i)])); 
    hold on;
    plot(csubp,rsubp,'ro');
    title('Figure2: Harris corners');
    % compute p_correct 
    Dist = dist2([csubp,rsubp], p_approx(1:2,:,i)');
    for j = 1 : 80
        Distj = Dist(:,j);
        n = find(Distj  == min(Distj));
        p_correct(1,j,i) = c(n);
        p_correct(2,j,i) = r(n);
    end
    subplot(1,2,2);
    imshow(eval(['im',int2str(i)])); 
    hold on;
    plot(p_correct(1,:,i),p_correct(2,:,i),'ro');
    title('Figure3: Grid points');
end
p_correct(3,:,:) = ones(1,80,4);
%compute homography from p_correct
H1_correct = homography2d(X_appro,p_correct(:,:,1));
H2_correct = homography2d(X_appro,p_correct(:,:,2));
H3_correct = homography2d(X_appro,p_correct(:,:,3));
H4_correct = homography2d(X_appro,p_correct(:,:,4));


disp('H1_correct =')
disp(H1_correct)
disp('H2_correct =')
disp(H2_correct)
disp('H3_correct =')
disp(H3_correct)
disp('H4_correct =')
disp(H4_correct)
% Computing the Intrinsic and Extrinsic parameters
 [K_correct,t1_correct,t2_correct,t3_correct,t4_correct,R1_newcorrect,R2_newcorrect,R3_newcorrect,R4_newcorrect] = compute_parameter(H1_correct,H2_correct,H3_correct,H4_correct);

% compute the errors
p_projected = zeros(3,80,4);
for i = 1 : 4
    p_projected(:,:,i) = eval(['H',int2str(i),'_correct']) *  X_appro;
    p_projected(:,:,i) = p_projected(:,:,i)./[p_projected(3,:,i);p_projected(3,:,i);p_projected(3,:,i)];
    error(:,i) = sqrt(sum((p_approx(1,:,i) - p_correct(1,:,i)).^2) + sum((p_approx(2,:,i) - p_correct(2,:,i)).^2));
    error_reprojection(:,i) = sqrt(sum((p_projected(1,:,i) - p_correct(1,:,i)).^2) + sum((p_projected(2,:,i) - p_correct(2,:,i)).^2));
end
disp('error')
disp(error)
disp('error_reprojection')
disp(error_reprojection)

%save('E:\\MATLAB\\cvas3\\SavedParameter.mat','K_correct','R1_newcorrect','R2_newcorrect','R3_newcorrect','R4_newcorrect','t1_correct','t2_correct','t3_correct','t4_correct','H1_correct','H2_correct','H3_correct','H4_correct');

