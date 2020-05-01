%设计技术指标
clear;
freq = [0.3, 0.5];
mag = [1, 0];
alpha_p = 1; %dB
alpha_s = 40; % dB

% 计算权函数所用
delta_1 = (10^(abs(alpha_p)/20) - 1) / (10^(abs(alpha_p)/20) + 1);
delta_2 = 10^(-abs(alpha_s)/20);
rip = [delta_1, delta_2];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% my_reme设计方法结果
hn = my_remez(freq, rip);
N = length(hn);

figure;
stem(0:N-1,hn);
title('滤波器冲激响应函数（自实现）');

figure;
freqz(hn);
title('滤波器频率特性（自实现）');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Matlab自带remez设计方法结果

[N, f0, m0, w] = remezord(freq, mag, rip);
hn = remez(N, f0, m0, w);
n = 0:N;

figure;
stem(n, hn);
title('滤波器冲激响应函数（Matlab内置）');

figure;
freqz(hn);
title('滤波器频率特性（Matlab内置）');

% kaiser window

N = 15;
window = kaiser(N,3.4);
b = fir1(N-1,0.4,window);
figure;
freqz(b,1)
title('Kaiser窗15阶滤波器')


% iir椭圆滤波器
% FDATool

% 过渡带宽与幅度误差
fp = [0.1, 0.2, 0.3 ,0.4, 0.5, 0.6];
fs = [0.7, 0.7, 0.7, 0.7, 0.7, 0.7];
f0 = [zeros(length(fp),1),fp',fs',ones(length(fp),1)];

figure;
passbands = fs - fp;
deltas = ones(length(passbands), 1);
for ii = 1:length(fp)
    [hn, delta] = remez(N, f0(ii,:), m0);
    deltas(ii) = delta;
    figure;
    freqz(hn);
    title(['passband: ',num2str(0),' - ',num2str(f0(ii,2)),', stopband: ',num2str(f0(ii,3)),' - ',num2str(1)]);
end

% 转化关系
fp = linspace(0.1,0.38,20);
fp = sort(fp, 'descend');
fs = linspace(0.42, 0.7, 20);
f0 = [zeros(length(fp),1),fp',fs',ones(length(fp),1)];
passbands = fs - fp;
deltas = ones(length(passbands), 1);
for ii = 1:20
    [hn, delta] = remez(N, f0(ii,:), m0);
    deltas(ii) = delta;
end

figure;
% subplot(2,1,1)
plot(passbands,deltas)
xlabel('passband');
ylabel('delta');
title('带宽-幅度误差关系（N=15)');

% subplot(2,1,2);
% plot(passbands, 20*los10(1-deltas));


% [N, f0, m0, w] = remezord(freq, mag, rip);
% hn = remez(N, f0, m0, w);
% n = 0:N;
% % f0 = [0, 0.3, 0.5, 1];
% m0 = [1, 1, 0, 0];


% for ii = 1:length(wp)
%    hn = remez(N, f0,
%    hn = my_remez([wp(ii),ws(ii)], rip);
%    subplot(3,
% end


% 相同过渡带宽

f0 = [0.3, 0.5];
alpha_p = [1, 1, 1, 0.6, 0.8, 1];
alpha_s = [40, 60, 80,40, 40, 40];
delta_1 = (10.^(abs(alpha_p)/20) - 1) ./ (10.^(abs(alpha_p)/20) + 1);
delta_2 = 10.^(-abs(alpha_s)/20);
rip = [delta_1', delta_2'];
% passbands = fs - fp;
% deltas = ones(length(passbands), 1);
figure;
for ii = 1:6
    deltas = rip(ii,:);
    hn = my_remez(f0, deltas);
    [h,w] = freqz(hn);
    
    N = length(hn);
    if ii==1
        subplot(3,2,1);
    elseif ii==2
        subplot(3,2,3);
    elseif ii==3
        subplot(3,2,5);
    elseif ii==4
        subplot(3,2,2);
    elseif ii==5
        subplot(3,2,4);
    else
        subplot(3,2,6);
    end
                       
%     if rem(ii,2)==0
%         subplot(3,2,(ii-3)*2);
%     else
%         subplot(3,2,ii*2-1)
%     end
    plot(w/pi, 20*log10(abs(h)));
    legend([num2str(N),'阶，通带',num2str(alpha_p(ii)),'dB，阻带',num2str(alpha_s(ii)),'dB']);
    grid;
%     if ii == 6
%         title('相同过渡带宽0.3-0.5不同幅度误差指标的幅频特性');
%     end
%     deltas(ii) = delta;
end

