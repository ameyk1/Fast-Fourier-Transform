% Engineer: Amey Kulkarni
% Module Name:  test_hw
% Project Name: Fast Fourier Transform (16-point)

clc;
clear;

sp = serial('/dev/tty.usbserial-A40136II', 'BaudRate', 115200, 'InputBufferSize', 8);
fopen(sp);

for n = 1:16*4
    if n == 5
        fwrite(sp, hex2dec('7f'), 'uint8');
    elseif n == 6
        fwrite(sp, hex2dec('ff'), 'uint8');
    else
        fwrite(sp, hex2dec('00'), 'uint8');
    end
end

%Keep reading until received all bytes
col = 1;
numberOfReceivedByte = 64;

rxb = uint8(zeros(1, numberOfReceivedByte));

while(numberOfReceivedByte > 0) 
    if(sp.BytesAvailable > 0)
        rxb(col) = fread(sp,1,'uint8');
        col = col + 1;
        numberOfReceivedByte = numberOfReceivedByte - 1;
    end
end

%Release everything
fclose(sp);
delete(sp);
clear sp;
delete(instrfindall);

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

out = zeros(1, 16);
col = 1;

for n = 1:4:16*4
    real = swapbytes(typecast([rxb(n) rxb(n+1)], 'uint16'));
    imag = swapbytes(typecast([rxb(n+2) rxb(n+3)], 'uint16'));
    out(col) = complex(real, imag);
    col = col + 1;
end

fprintf('MATLAB Output')
fft(in)/16

fprintf('Hardware Output')
out

difff(fft(in./16), out)


