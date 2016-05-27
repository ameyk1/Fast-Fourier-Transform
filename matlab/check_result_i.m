% Engineer: Amey Kulkarni
% Module Name:  check_result_i
% Project Name: Fast Fourier Transform (16-point

clc;
clear;

% Input data in 8.8 format
in(1) = 32767 + i*0;
in(2) = 0 + i*0;
in(3) = 0 + i*0;
in(4) = 0 + i*0;
in(5) = 0 + i*0;
in(6) = 0 + i*0;
in(7) = 0 + i*0;
in(8) = 0 + i*0;
in(9) = 0 + i*0;
in(10) = 0 + i*0;
in(11) = 0 + i*0;
in(12) = 0 + i*0;
in(13) = 0 + i*0;
in(14) = 0 + i*0;
in(15) = 0 + i*0;
in(16) = 0 + i*0;

% Output data from simulation in 12.4 format
out(1) = 2047 + i*0;
out(2) = 2047 + i*0;
out(3) = 2047 + i*0;
out(4) = 2047 + i*0;
out(5) = 2047 + i*0;
out(6) = 2047 + i*0;
out(7) = 2047 + i*0;
out(8) = 2047 + i*0;
out(9) = 2047 + i*0;
out(10) = 2047 + i*0;
out(11) = 2047 + i*0;
out(12) = 2047 + i*0;
out(13) = 2047 + i*0;
out(14) = 2047 + i*0;
out(15) = 2047 + i*0;
out(16) = 2047 + i*0;

% Compare simulation output to MATLAB FFT
difff(fft(in./256), out./16, 'MATLAB', 'RTL Simulation')
