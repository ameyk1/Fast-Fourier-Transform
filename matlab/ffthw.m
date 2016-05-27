% Engineer: Amey Kulkarni
% Module Name:  ffthw
% Project Name: Fast Fourier Transform (16-point)

function result = ffthw(input)

%clc;
%clear;
%input = [0 32767 0 0 0 0 0 0 0 0 0 0 0 0 0 0];

N = 16;

w_lut = zeros(1, N/2);

for n = 0:N/2-1
    w_lut(n+1) = exp((-j * 2 * pi * n) / N);
    w_lut(n+1) = round(w_lut(n+1) * (2^14))/(2^14);
    %fprintf ('w[%d] = %.14f + %.14fj\n', n, real(w_lut(n+1)), imag(w_lut(n+1)));
end

read_addr_lut = [0 8 4 12 2 10 6 14 1 9 5 13 3 11 7 15; ...
                 0 4 8 12 2 6 10 14 1 5 9 13 3 7 11 15; ...
                 0 2 8 10 4 6 12 14 1 3 9 11 5 7 13 15; ...
                 0 1 8 9 4 5 12 13 2 3 10 11 6 7 14 15];             

w_addr_lut = [0 0 0 0 0 0 0 0; ...
              0 4 0 4 0 4 0 4; ...
              0 2 4 6 0 2 4 6; ...
              0 1 2 3 4 5 6 7];
          
for stage = 1:4

    for butterfly = 1:N/2
    
        % Determine the addresses of the values for this stage/butterfly.
        a_addr = read_addr_lut(stage, 2*butterfly-1) + 1;
        b_addr = read_addr_lut(stage, 2*butterfly) + 1;
        w_addr = w_addr_lut(stage, butterfly) + 1;
        
        % Get the values of a, b, and w.
        a = input(a_addr);
        b = input(b_addr);
        w = w_lut(w_addr);
        
        % Multiply b by w and truncate the last 2 bits of the result.
        p = floor((b*w) * 2^20)/2^20;

        % Calculate the full 32-bit x and y values.
        x_full = a + p;
        y_full = a - p;
    
        % Saturate the x and y values down to 16 bits.
        x = saturate(x_full);
        y = saturate(y_full);
        
        % Save the new values back to the array.
        input(a_addr) = x;
        input(b_addr) = y;
            
    end
    
    fprintf('stage %d\n', stage);
    for i = 1:16
        fprintf('result[%d] = %g %g\n', i, ...
            real(input(read_addr_lut(1, i)+1))*256, ...
            imag(input(read_addr_lut(1, i)+1))*256);
    end
    fprintf('\n');
end

% Output the results in the correct order.
result = zeros(1, N);

for i = 1:16
    result(1, i) = input(read_addr_lut(1, i)+1);
    fprintf('result[%d] = %g %g\n', i, ...
        real(input(read_addr_lut(1, i)+1))*256, ...
        imag(input(read_addr_lut(1, i)+1))*256);
end
