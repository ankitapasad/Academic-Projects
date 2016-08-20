

A = imread('barbara256.png');

%% Initializations
t = 8; % patchsize
n = t*t; % actual number of measurements
f = 0.9;
m = ceil(f*n); % compressed number of measurements
U = kron(dctmtx(8), dctmtx(8)'); % 2-D dct matrix
[rows,cols] = size(A);
no_patches = length(1:(t/2):rows-t+1)*length(1:(t/2):cols-t+1);
y = zeros(m,no_patches); % compressed measurement matrix
x = zeros(n,no_patches); % actual measurement matrix
k = 1;

%% Generate matrix phi (64 x 64) ~ N(0,1)
phi = randn(n);
phi_m = phi(1:m,:);
A = phi_m*U;  % m x 64
%% Dividing into overlapping patches and generating measurements
for i = 1:(t/2):rows-t+1
    for j = 1:(t/2):cols-t+1
        temp_patch = A(i:i+t-1,j:j+t-1);
        x(:,k) = reshape(temp_patch,n,1);
        y(:,k) = phi_m*x(:,k);
        y(:,k) = y(:,k) + 0.05*mean(abs(y(:,k)))*randn(m,1);
        k = k+1;
    end
end

%% Applying OMP
A_modified = zeros(m,n);
for j = 1:n
    A_modified(:,j) = A(:,j)./(norm(A(:,j),2)*norm(A(:,j),2));
end

for i = 1:no_patches
    residual = y(:,i);
    s = 0;
    j = 0;
    k = 1;
    elsilon = 0.1;
    while norm(r,2)>epsilon
        [value,index] = max(r'*A_modified); % 1 x n
        support_set(k) = index;
        k = k+1;
    end
end

