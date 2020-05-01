function [N, f0, m0, w] = my_remezord(freq, mag, rip)
% freq = [fp, fs]
% rip = [delta_1, delta_2]
% mag = [1, 0]
freq = freq * pi;

