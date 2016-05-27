% Engineer: Amey Kulkarni
% Module Name:  send_samples
% Project Name: Fast Fourier Transform (16-point)


function receivedData = send_samples( samples, PORT, BAUD)
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

%Send all bytes through UART

for col = 1:8
  fwrite(sp, samples(col), 'uint8');
end


%Keep reading until received all bytes
col = 1;
numberOfReceivedByte = 8; % change this depending on how many bytes you want to receive from LDPC decoder

receivedData = uint8(zeros(1,numberOfReceivedByte));

while(numberOfReceivedByte > 0) 
    if(sp.BytesAvailable > 0)
        receivedData(col) = fread(sp,1,'uint8');
        col = col + 1;
        numberOfReceivedByte = numberOfReceivedByte - 1;
    end
end

receivedData
sp.BytesAvailable

%Release everything
fclose(sp);
delete(sp);
clear sp;
delete(instrfindall);
