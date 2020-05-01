function N = N_appro(wp, ws, delta_1, delta_2)
diff_f = (ws - wp)/2/pi;
g = 11.012 + 0.51244*log10(delta_1/delta_2);
D = (0.005309*(log10(delta_1)^2) + 0.07114*log10(delta_1) - 0.4761) * log10(delta_2)...,
    - (0.00266*(log10(delta_1)^2) + 0.594111*log10(delta_1) + 0.4278);
N = (D - g*(diff_f)^2) / diff_f +1;
if rem(ceil(N),2) == 0
    N = ceil(N)+1;
else
    N = ceil(N);
end