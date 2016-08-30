cube_pixel = [
    422 323 1; 178 323 1; 118 483 1; 482 483 1; 
    438 73  1; 162 73  1; 78  117 1; 522 117 1]; 
plot(cube_pixel(:,1),cube_pixel(:,2),'o');
title('cube pixel');

cube = [
        2  2 2 1; -2  2 2 1; -2  2 -2 1; 2  2 -2 1;
        2 -2 2 1; -2 -2 2 1; -2 -2 -2 1; 2 -2 -2 1
        ];
for i = 1 : 8
    P(2*i-1:2*i,:)=[
        cube(i,:), 0, 0, 0, 0, -cube_pixel(i,1)*cube(i,:);
        0, 0, 0, 0, cube(i,:), -cube_pixel(i,2)*cube(i,:)
        ];
end
% Print Matrix P
disp('Matrix P =')
disp(P)

[Up,Sp,Vp] = svd(P);
for i = 1 : 3
    M(i,:) = Vp(4*i-3:4*i,12)';
end
% Print Matrix M
disp('Matrix M =')
disp(M)

[Um,Sm,Vm] = svd(M);
center = Vm(1:3,4)/Vm(4,4);
disp('center =')
disp(center)

%print M'
m = M(:,1:3)/M(3,3);
disp('3x3 Matrix of M =')
disp(m)

% compute Rx, Sitax, N 
cos = m(3,3) / sqrt(m(3,3).^2 + m(3,2).^2);
sin = -m(3,2) / sqrt(m(3,3).^2 + m(3,2).^2);
Sitax = asin(sin);
Rx = [
    1   0   0; 
    0 cos -sin; 
    0 sin cos
    ];
N = m*Rx;
disp('Sitax =')
disp(Sitax)
disp('Matrix Rx =')
disp(Rx)
disp('Matrix N =')
disp(N)

% compute Rz, Sitaz 
cos = N(2,2) / sqrt(N(2,1).^2 + N(2,2).^2);
sin = -N(2,1) / sqrt(N(2,1).^2 + N(2,2).^2);
Rz = [
    cos -sin 0;
    sin cos 0;
    0 0 1
    ];
Sitaz = asin(sin);
disp('Sitaz =')
disp(Sitaz)
disp('Matrix Rz =')
disp(Rz)

% compute K
K = N * Rz;
K = K / K(3,3);
disp('K =');
disp(K);
