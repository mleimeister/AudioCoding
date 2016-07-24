function Y_rescaled = rescale_mdct(Y_quant, masking_thresh)
% Applies dequantization to MDCT coefficients using the masking
% threshold.
%
% Input:
%           Y_quant:    quantized mdct coefficients
%           masking_thresh: masking threshold per block
%
% Output:   
%           Y_rescaled: rescaled mdct coefficients

[numBlocks, blockLength] = size(Y_quant);

Y_rescaled = zeros(numBlocks+1, blockLength);

for k = 1:numBlocks                                   
    % rescale quantized MDCT data
    for m = 1:2:blockLength/2-2
        Y_rescaled(k,2*m-1) = Y_quant(k,2*m-1)*10^(masking_thresh(m,k)/20);
        Y_rescaled(k,2*m) = Y_quant(k,2*m)*10^(masking_thresh(m,k)/20);
        Y_rescaled(k,2*m+1) = Y_quant(k,2*m+1)*10^(masking_thresh(m,k)/20);
        Y_rescaled(k,2*m+2) = Y_quant(k,2*m+2)*10^(masking_thresh(m,k)/20);
    end
end