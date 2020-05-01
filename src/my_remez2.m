function hn = my_remez2(freq, rip)
% 第一类滤波器

% 估计长度
global wp;
global ws;
global delta_1;
global delta_2;
freq = freq*pi;
wp = freq(1);
ws = freq(2);
delta_1 = rip(1);
delta_2 = rip(2);
global r;
global N;
N = N_appro(wp, ws, delta_1, delta_2);
% hn = ones(1,N);
r = (N+1)/2;

% 迭代求解
foot = (wp + pi - ws) / (r-1);
points = [linspace(0, wp, round(wp/foot) + 1), linspace(ws, pi, round((pi-ws)/foot) + 1)]';
% points为列向量
% factors = ones(1, r+1); % alpha:0--r-1 delta
H_d = H_define(points); % 0--r
M_construct = Matrix_construct(points); % (r+1)×(r+1)

factors = linsolve(M_construct, H_d);
delta = delta_2; % 上一次的delta值


    
delta_error = 1e-4;
while abs(factors(end) - delta) > delta_error
% factor(end)为最新delta值
delta = factors(end);
E = @Error;
points =  Extreme_points(E, r+1, delta, factors(1:(end-1))); % r + 1个极值点, r+1 = (r-3) + 4
H_d = H_define(points); % 0--r
M_construct = Matrix_construct(points); % (r+1)×(r+1)
factors = linsolve(M_construct, H_d);

end

alphas = factors(1:(end-1));
sample_points = (0:(N-1))'*2*pi / N;
H_k = Design(sample_points, alphas).*exp(-1i*(sample_points)*(N-1)/2);
hn = ifft(H_k);
aaa=maigc(3);
% clear global;
end


% 理想频率响应
function H_d = H_define(w)
global wp;
global ws;
H_d = ones(length(w), 1);
H_d(w <= wp) = 1;
H_d(w >= ws) = 0;

end

% 权函数
function W = Weight(w)
global wp;
global ws;
global delta_1;
global delta_2;
W = ones(length(w), 1); % 全用列向量
W(w <= wp) = delta_2/delta_1;
W(w >= ws) = 1;
% if w <= wp
%     W = rip(2)/rip(1);
% else
%     W = 1;
% end
end


% 设计函数--频率响应
function P = Design(w,alphas)
% alphas长度r
% P = 0;
global r;
P = zeros(length(w),1);
for ii = 0:(r-1)
    P = P + alphas(ii+1)*cos(ii*w);
end

aaaa=magic(3);%%%%%%%%%%%%%%%%
end

% 误差函数
function E = Error(w, alphas)
E = Weight(w).*(H_define(w)-Design(w, alphas));
aaa=magic(3);%%%%%%%%%%%%%%
end

% 系数前的构造矩阵
function M = Matrix_construct(points)
% w 长度 lrngth = r+1
% points为列向量
M = ones(length(points));
M(:,end) = ones(length(points),1) ./ Weight(points);
for ii = 1:length(points)
    for jj = 1:(length(points)-1)
       M(ii,jj) = cos((jj-1)*points(ii)); 
    end
end
end

% 返回 r+1 个极值点
function points = Extreme_points(E, n, delta, alphas)
% E 为 Error函数句柄
global wp;
global ws;
global N;
n = n-4;
M = 10*N;
eps = 1e-2; 
w = [linspace(eps, wp-eps, M), linspace(ws+eps, pi-eps, M)]'; % 密集的频率点组
points = w(abs(diff(sign(diff(E(w, alphas))))) == 2); % 极值点
% 此时points为列向量
% points = points(abs(E(points)) > delta);
% 若满足要求的极值点多于n个，取前n个较大者
[values, index] = sort(abs(E(points, alphas)), 'descend');
points = points(index);


% if length(points)>n
%     points = points(1:n);
% else
%     points =
% end
points = points(1:n);
points = [points; 0; wp; ws; pi];
% 返回points为列向量
end

