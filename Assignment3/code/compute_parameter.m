function [K,t1,t2,t3,t4,R1_new,R2_new,R3_new,R4_new] = compute_parameter(H1, H2,H3,H4)

% First compute V of the 4 grid
V = [];
v11 = [H1(1,1)^2, 2*H1(1,1)*H1(2,1), H1(2,1)^2, 2*H1(3,1)*H1(1,1), 2*H1(3,1)*H1(2,1), H1(3,1)^2];
v12 = [H1(1,1)*H1(1,2), H1(1,1)*H1(2,2)+H1(2,1)*H1(1,2), H1(2,1)*H1(2,2),H1(3,1)*H1(1,2)+H1(1,1)*H1(3,2), H1(3,1)*H1(2,2)+H1(2,1)*H1(3,2), H1(3,1)*H1(3,2)];
v22 = [H1(1,2)^2, 2*H1(1,2)*H1(2,2), H1(2,2)^2, 2*H1(3,2)*H1(1,2), 2*H1(3,2)*H1(2,2), H1(3,2)^2];
V = [V;v12;(v11-v22)];

v11 = [H2(1,1)^2, 2*H2(1,1)*H2(2,1), H2(2,1)^2, 2*H2(3,1)*H2(1,1), 2*H2(3,1)*H2(2,1), H2(3,1)^2];
v12 = [H2(1,1)*H2(1,2), H2(1,1)*H2(2,2)+H2(2,1)*H2(1,2), H2(2,1)*H2(2,2), H2(3,1)*H2(1,2)+H2(1,1)*H2(3,2), H2(3,1)*H2(2,2)+H2(2,1)*H2(3,2), H2(3,1)*H2(3,2)];
v22 = [H2(1,2)^2, 2*H2(1,2)*H2(2,2), H2(2,2)^2, 2*H2(3,2)*H2(1,2), 2*H2(3,2)*H2(2,2), H2(3,2)^2];
V = [V;v12;(v11-v22)];

v11 = [H3(1,1)^2, 2*H3(1,1)*H3(2,1), H3(2,1)^2, 2*H3(3,1)*H3(1,1), 2*H3(3,1)*H3(2,1), H3(3,1)^2];
v12 = [H3(1,1)*H3(1,2), H3(1,1)*H3(2,2)+H3(2,1)*H3(1,2), H3(2,1)*H3(2,2), H3(3,1)*H3(1,2)+H3(1,1)*H3(3,2), H3(3,1)*H3(2,2)+H3(2,1)*H3(3,2), H3(3,1)*H3(3,2)];
v22 = [H3(1,2)^2, 2*H3(1,2)*H3(2,2), H3(2,2)^2, 2*H3(3,2)*H3(1,2), 2*H3(3,2)*H3(2,2), H3(3,2)^2];
V = [V;v12;(v11-v22)];

v11 = [H4(1,1)^2, 2*H4(1,1)*H4(2,1), H4(2,1)^2, 2*H4(3,1)*H4(1,1), 2*H4(3,1)*H4(2,1), H4(3,1)^2];
v12 = [H4(1,1)*H4(1,2), H4(1,1)*H4(2,2)+H4(2,1)*H4(1,2), H4(2,1)*H4(2,2), H4(3,1)*H4(1,2)+H4(1,1)*H4(3,2), H4(3,1)*H4(2,2)+H4(2,1)*H4(3,2), H4(3,1)*H4(3,2)];
v22 = [H4(1,2)^2, 2*H4(1,2)*H4(2,2), H4(2,2)^2, 2*H4(3,2)*H4(1,2), 2*H4(3,2)*H4(2,2), H4(3,2)^2];
V = [V;v12;(v11-v22)];
disp('V=')
disp(V)
% computer and print intrinsic parameters
[Ut,St,Vt] = svd(V);
B= [
    Vt(1,6),Vt(2,6),Vt(4,6);
    Vt(2,6),Vt(3,6),Vt(5,6); 
    Vt(4,6),Vt(5,6), Vt(6,6)
    ];
disp(' matrix B =')
disp(B)

v0 = (B(1,2)*B(1,3)-B(1,1)*B(2,3))/(B(1,1)*B(2,2)-B(1,2)^2);
lambda = B(3,3)-(B(1,3)*B(1,3)+v0*(B(1,2)*B(1,3)-B(1,1)*B(2,3)))/B(1,1);
alpha = sqrt(lambda/B(1,1));
beta = sqrt(lambda*B(1,1)/(B(1,1)*B(2,2)-B(1,2)^2));
gamma = -B(1,2)*(alpha^2)*beta/lambda;
u0 = gamma*v0/alpha - B(1,3)*(alpha^2)/gamma;
K = [
    alpha gamma u0;
    0 beta v0; 
    0 0 1];
disp('lambda =')
disp(lambda)
disp('alpha =')
disp(alpha)
disp('beta =')
disp(beta)
disp('gamma =')
disp(gamma)
disp('v0 =')
disp(v0)
disp('u0 =')
disp(u0)
disp('K =')
disp(K)
% computer and print extrinsic parameters
% R, t for images2
lambda1 = 1/norm(inv(K)*H1(:,1));
lambda2 = 1/norm(inv(K)*H1(:,2));
R1(:,1) = inv(K)*H1(:,1) * lambda1;
R1(:,2) = inv(K)*H1(:,2) * lambda2;
R1(:,3) = cross(R1(:,1),R1(:,2));
t1 = inv(K)*H1(:,3) * (lambda1+lambda2)/2;
disp('t1 =')
disp(t1)
disp('R1 =')
disp(R1)
disp('R1T*R1=')
disp(R1'*R1)
% R, t for images9
lambda1 = 1/norm(inv(K)*H2(:,1));
lambda2 = 1/norm(inv(K)*H2(:,2));
R2(:,1) = inv(K)*H2(:,1) * lambda1;
R2(:,2) = inv(K)*H2(:,2) * lambda2;
R2(:,3) = cross(R2(:,1),R2(:,2));
t2 = inv(K)*H2(:,3) * (lambda1+lambda2)/2;
disp('t2 =')
disp(t2)
disp('R2 =')
disp(R2)
disp('R2T*R2=')
disp(R2'*R2)
% R, t for images12
lambda1 = 1/norm(inv(K)*H3(:,1));
lambda2 = 1/norm(inv(K)*H3(:,2));
R3(:,1) = inv(K)*H3(:,1) * lambda1;
R3(:,2) = inv(K)*H3(:,2) * lambda2;
R3(:,3) = cross(R3(:,1),R3(:,2));
t3 = inv(K)*H3(:,3) * (lambda1+lambda2)/2;
disp('t3 =')
disp(t3)
disp('R3 =')
disp(R3)
disp('R3T*R3=')
disp(R3'*R3)
% R, t for images20
lambda1 = 1/norm(inv(K)*H4(:,1));
lambda2 = 1/norm(inv(K)*H4(:,2));
R4(:,1) = inv(K)*H4(:,1) * lambda1;
R4(:,2) = inv(K)*H4(:,2) * lambda2;
R4(:,3) = cross(R4(:,1),R4(:,2));
t4 = inv(K)*H4(:,3) * (lambda1+lambda2)/2;
disp('t4 =')
disp(t4)
disp('R4 =')
disp(R4)
disp('R4T*R4=')
disp(R4'*R4)

% compute and print new R and RTR after enforcing the rotation matrix constraints
[U,~,V] = svd(R1);
R1_new = U*V';
disp('R1_new =')
disp(R1_new)
disp('(R1_new)T*R1_new=')
disp(R1_new'*R1_new)

[U,~,V] = svd(R2);
R2_new = U*V';
disp('R2_new =')
disp(R2_new)
disp('(R2_new)T*R2_new=')
disp(R2_new'*R2_new)

[U,~,V] = svd(R3);
R3_new = U*V';
disp('R3_new =')
disp(R3_new)
disp('(R3_new)T*R3_new=')
disp(R3_new'*R3_new)

[U,~,V] = svd(R4);
R4_new = U*V';
disp('R4_new =')
disp(R4_new)
disp('(R4_new)T*R4_new=')
disp(R4_new'*R4_new)
