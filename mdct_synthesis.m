function x = mdct_synthesis(Y)
% Apply an MDCT synthesis filterbank using a sine window.
%
% Input:    
%           Y: mdct coefficients in the form 
%              (numBlocks+1 x blockLength)
%
% Output:   
%           x: synthesized audio signal

numBlocks = size(Y,1) - 1;
blockLength = size(Y,2);

% setup MDCT and DCT matrices
F = mdct_polyphase_matrix(blockLength);            
T = dct_4_matrix(blockLength);

% apply inverse DCT 4 transform
Y_inv_dct = Y*inv(T);

% apply delay matrix, i.e. shift the right blocks by one block
Y_inv_dct(2:numBlocks+1, blockLength/2+1:blockLength) = ...
    Y_inv_dct(1:numBlocks, blockLength/2+1:blockLength);
% the first line is not set to zero during the loop
Y_inv_dct(1, blockLength/2+1:blockLength) = zeros(1,blockLength/2);            

% apply inverse polyphase matrix
X = Y_inv_dct*inv(F);

x = zeros(length(X(:,1))*blockLength,1);

for k = 1:length(X(:,1))
    for m = 1:blockLength
        x((k-1)*blockLength+m) = X(k,m);
    end
end


