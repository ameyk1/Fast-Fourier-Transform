% Engineer: Amey Kulkarni
% Module Name:  check_result_iv
% Project Name: Fast Fourier Transform (16-point)

clc;
clear;

% Input data in 8.8 format
in(1) = -2561 + i*-3377;
in(2) = -2569 + i*-32188;
in(3) = -14817 + i*15351;
in(4) = -28260 + i*-31024;
in(5) = -30765 + i*31905;
in(6) = -1165 + i*13370;
in(7) = -14399 + i*-15020;
in(8) = 19194 + i*-16779;
in(9) = 30233 + i*-9814;
in(10) = -3968 + i*6186;
in(11) = 32245 + i*20839;
in(12) = 27959 + i*17329;
in(13) = 13304 + i*13889;
in(14) = -16235 + i*-13473;
in(15) = -20234 + i*13674;
in(16) = 10751 + i*-26756;

% Output data from simulation in 12.4 format
out(1) = -82 + i*-994;
out(2) = -8807 + i*3553;
out(3) = 7156 + i*-8548;
out(4) = 473 + i*77;
out(5) = 3658 + i*3208;
out(6) = -2149 + i*-4429;
out(7) = -1169 + i*2887;
out(8) = -3813 + i*3582;
out(9) = -794 + i*9424;
out(10) = -739 + i*8453;
out(11) = 3176 + i*-5334;
out(12) = -5172 + i*-3190;
out(13) = -232 + i*-3490;
out(14) = 7997 + i*5046;
out(15) = 2117 + i*-3754;
out(16) = -4194 + i*-9881;

% Compare simulation output to MATLAB FFT
difff(fft(in./256), out./16, 'MATLAB', 'RTL Simulation')
