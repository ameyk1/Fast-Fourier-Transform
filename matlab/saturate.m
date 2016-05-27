% Engineer: Amey Kulkarni
% Module Name:  satuarate
% Project Name: Fast Fourier Transform (16-point)

function result = saturate(x)

if (real(x)*256 > 32767)
    x = 32767/256 + i*imag(x);
elseif (real(x)*256 < -32768)
    x = -32768/256 + i*imag(x);
else
    x = round(real(x)*256)/256 + i*imag(x);
end

if (imag(x)*256 > 32767)
    x = real(x) + i*32767/256;
elseif (imag(x)*256 < -32768)
    x = real(x) - i*32768/256;   
else
    x = real(x) + i*round(imag(x)*256)/256;                    
end

result = x;
