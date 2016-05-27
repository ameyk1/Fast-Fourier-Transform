% Engineer: Amey Kulkarni
% Module Name:  check_result_iii
% Project Name: Fast Fourier Transform (16-point)

clc;
clear;

% Input data in 8.8 format
in(1) = 32767 + i*0;
in(2) = 32767 + i*0;
in(3) = 32767 + i*0;
in(4) = 32767 + i*0;
in(5) = 32767 + i*0;
in(6) = 32767 + i*0;
in(7) = 0 + i*0;
in(8) = 0 + i*0;
in(9) = 0 + i*0;
in(10) = 0 + i*0;
in(11) = 0 + i*0;
in(12) = 32767 + i*0;
in(13) = 32767 + i*0;
in(14) = 32767 + i*0;
in(15) = 32767 + i*0;
in(16) = 32767 + i*0;

% Output data from simulation in 12.4 format
out(1) = 22527 + i*0;
out(2) = 8727 + i*0;
out(3) = -4945 + i*0;
out(4) = 718 + i*0;
out(5) = 2048 + i*0;
out(6) = -2417 + i*-1;
out(7) = 848 + i*0;
out(8) = 1159 + i*0;
out(9) = -2048 + i*0;
out(10) = 1159 + i*-1;
out(11) = 848 + i*0;
out(12) = -2416 + i*-1;
out(13) = 2048 + i*0;
out(14) = 719 + i*-1;
out(15) = -4945 + i*0;
out(16) = 8727 + i*-2;

% Compare simulation output to MATLAB FFT
difff(fft(in./256), out./16, 'MATLAB', 'RTL Simulation')
