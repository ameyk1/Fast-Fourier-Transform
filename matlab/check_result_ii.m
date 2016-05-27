% Engineer: Amey Kulkarni
% Module Name:  check_result_ii
% Project Name: Fast Fourier Transform (16-point)

clc;
clear;

% Input data in 8.8 format
in(1) = 0 + i*0;
in(2) = 32767 + i*0;
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
out(2) = 1891 + i*-784;
out(3) = 1447 + i*-1448;
out(4) = 783 + i*-1892;
out(5) = 0 + i*-2048;
out(6) = -784 + i*-1892;
out(7) = -1448 + i*-1448;
out(8) = -1892 + i*-784;
out(9) = -2048 + i*0;
out(10) = -1892 + i*783;
out(11) = -1448 + i*1447;
out(12) = -784 + i*1891;
out(13) = 0 + i*2047;
out(14) = 783 + i*1891;
out(15) = 1447 + i*1447;
out(16) = 1891 + i*783;

% Compare simulation output to MATLAB FFT
difff(fft(in./256), out./16, 'MATLAB', 'RTL Simulation')
