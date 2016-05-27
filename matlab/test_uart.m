% Engineer: Amey Kulkarni
% Module Name:  test_uart
% Project Name: Fast Fourier Transform (16-point)

clc;
clear;

%samples = [hex2dec('de'), hex2dec('ad'), hex2dec('be'), hex2dec('ef'), ...
%           hex2dec('fe'), hex2dec('ed'), hex2dec('fa'), hex2dec('ce')];

samples = [222   172   190   239   254   237   250   205];

send_samples(samples, '/dev/tty.usbserial-A40136II', 115200);
