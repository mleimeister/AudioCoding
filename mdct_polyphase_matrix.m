function F = mdct_polyphase_matrix(blockLength)
% Computes MDCT polyphase matrix for the sine window.

% allocate polyphase matrix
F = zeros(blockLength);  

% window function
n = 0:2*blockLength-1;
h = sin(pi/(2*blockLength)*(n+0.5));  

% set up polyphase matrix with elements of window function
for k = 1:blockLength/2                                                            
    F(k, blockLength/2-k+1) = h(k);
    F(k, blockLength/2+k) = h(blockLength+1+(k-1));
end

for k = 1:blockLength/2
    F(blockLength/2+k,k) = h(blockLength/2+k);
    F(blockLength/2+k, blockLength-k+1) = -h(1.5*blockLength+k);
end