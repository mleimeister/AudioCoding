function T = dct_4_matrix(blockLength)
% Computes DCT-4 transformation matrix for a given
% block length.

T = zeros(blockLength);                           
for m = 1:blockLength
    for k = 1:blockLength
        % DCT indices run from 0 to N-1
        T(m,k) = cos(pi/blockLength*((k-1)+0.5)*((m-1)+0.5));     
    end
end