% Engineer: Amey Kulkarni
% Module Name:  calculate_w
% Project Name: Fast Fourier Transform (16-point)

clc;
clear;

N = 16;
W = zeros(1, N/2);
fractional_bits = 14;

for n = 0:N/2-1
    W(n+1) = exp((-j * 2 * pi * n) / N);
    fprintf ('    W[%2d] = %.14f + %.14fj\n', n, real(W(n+1)), imag(W(n+1)));
end

fprintf('\n');

for n = 0:N/2-1
    W(n+1) = round(W(n+1) * (2^fractional_bits))/(2^fractional_bits);
    fprintf ('    W[%2d] = %.14f + %.14fj\n', n, real(W(n+1)), imag(W(n+1)));
end

fprintf('\n');

for n = 0:N/2-1
    fprintf ('   %2d: w = {%d, %d};\n', n, real(W(n+1)) * 2^14, imag(W(n+1)) * 2^14);
end
