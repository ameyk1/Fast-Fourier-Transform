% Engineer: Amey Kulkarni
% Module Name:  UART
% Project Name: Fast Fourier Transform (16-point)

function receivedData= UART(PORT, BAUD)
% Sends lambda to FPGA through UART and FPGA returns
%        PORT: The UART port
%        BAUD: The UART baud rate 


%Open serial port with given port & baud
sp = serial(PORT, 'BaudRate', BAUD, 'InputBufferSize', 8);
fopen(sp);

%Ensure serial port can be openned
if(strcmp(sp.Status,'closed'))
    delete(sp);
    clear sp;
    delete(instrfindall);
    error('Error: Unable to open serial port');
end

%Define input values
%val_in = [hex2dec('7f'), hex2dec('ff'), hex2dec('00'), hex2dec('00'), hex2dec('00'), hex2dec('00'), hex2dec('00'), hex2dec('00'), hex2dec('00'), hex2dec('00'), hex2dec('00'), hex2dec('00'), hex2dec('00'), hex2dec('00'), hex2dec('00'), hex2dec('00'), hex2dec('00'), hex2dec('00'), hex2dec('00'), hex2dec('00'), hex2dec('00'), hex2dec('00'), hex2dec('00'), hex2dec('00'), hex2dec('00'), hex2dec('00'), hex2dec('00'), hex2dec('00'), hex2dec('00'), hex2dec('00'), hex2dec('00'), hex2dec('00'), hex2dec('00'), hex2dec('00'), hex2dec('00'), hex2dec('00'), hex2dec('00'), hex2dec('00'), hex2dec('00'), hex2dec('00'), hex2dec('00'), hex2dec('00'), hex2dec('00'), hex2dec('00'), hex2dec('00'), hex2dec('00'), hex2dec('00'), hex2dec('00'), hex2dec('00'), hex2dec('00'), hex2dec('00'), hex2dec('00'), hex2dec('00'), hex2dec('00'), hex2dec('00'), hex2dec('00'), hex2dec('00'), hex2dec('00'), hex2dec('00'), hex2dec('00'))];

%Send all bytes through UART
fwrite(sp, hex2dec('7f'), 'uint8');
fwrite(sp, hex2dec('ff'), 'uint8');

for col = 1:62
  fwrite(sp,hex2dec('00'),'uint8');
end


%Keep reading until received all bytes
col = 1;
numberOfReceivedByte = 64; % change this depending on how many bytes you want to receive from LDPC decoder

receivedData = uint8(zeros(1,numberOfReceivedByte));

while(numberOfReceivedByte > 0) 
    if(sp.BytesAvailable > 0)
        receivedData(col) = fread(sp,1,'uint8');
        col = col + 1;
        numberOfReceivedByte = numberOfReceivedByte - 1;
    end
end

receivedData

%Release everything
fclose(sp);
delete(sp);
clear sp;
delete(instrfindall);
