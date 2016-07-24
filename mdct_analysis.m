function Y = mdct_analysis(X)
% Apply an MDCT analysis filterbank using a sine window.
%
% Input:    
%           X: audio signal in non-overlapping block 
%              (numBlocks x blockLength)
%
% Output:   
%           Y: mdct coefficients (numBlocks/2+1 x blockLength)

[numBlocks, blockLength] = size(X);
                                
% setup MDCT and DCT matrices
F = mdct_polyphase_matrix(blockLength);            
T = dct_4_matrix(blockLength);

% apply matrix F to input signal
XF = X*F;

% apply delay matrix, i.e. shift the left blocks by one block
XFD = zeros(numBlocks+1, blockLength);

XFD(2:numBlocks+1, 1:blockLength/2) = XF(1:numBlocks, 1:blockLength/2);
XFD(1:numBlocks, blockLength/2+1:blockLength) = XF(1:numBlocks, blockLength/2+1:blockLength);

% apply DCT 4 transformation matrix
Y = XFD*T;