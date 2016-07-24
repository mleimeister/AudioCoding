function [Y_quant, masking_thresh] = quantize_mdct(Y_mdct, X, fs)
% Compute masking threshold and apply quantization to
% scaled MDCT coefficients.
%
% Input:
%           Y_mdct: mdct coefficients
%           X:      blocked audio data
%           fs:     sample rate
%
% Output:
%           Y_quant: quantized mdct coefficients
%           masking_thresh: masking threshold per block

[numBlocks, blockLength] = size(X);

Y_quant = zeros(numBlocks+1, blockLength);

% compute the masking threshhold for each block and quantize MDCT
% coefficients

masking_thresh = zeros(blockLength/2, numBlocks);

for k = 1:numBlocks 
    
    % compute fft of the k'th block in dB
    spec = 20*log10(abs(fft(X(k,:))));        
    
    slopes = zeros(blockLength/2);
    
    for m = 0:blockLength/2-1  
        
        % center frequency
        f = (m/blockLength)*fs;   
       
        % critical bandwidth, f has to be in kHz !
        delta_fg = 25+75*(1+1.4*(f/1000)^2)^(0.69);   
        
        slope_below_f = (27*fs)/(delta_fg*blockLength);
        slope_above_f = (10*fs)/(delta_fg*blockLength);
        
        % masking frequency at center frequ. is fft value -5.5 dB
        slopes(m+1,m+1) = spec(m+1)-10.5; 
        
        for n = m-1:-1:0        % iterate over all frequencies from 0 to f
            slopes(m+1,n+1) = slopes(m+1,n+2) - slope_below_f;
        end
        
        for n = m+1:blockLength/2-1       % iterate over all frequencies from f to f_nyq
            slopes(m+1,n+1) = slopes(m+1,n) - slope_above_f;
        end
        
    end
    
    % now the k'th line of SLOPES contains the masking curve of center frequency f_k, 
    % the masking curve for the whole block is now found by taking the maximum at every
    % center frequency
    
    for m = 1:blockLength/2
        masking_thresh(m,k) = max(slopes(:,m)); 
    end
   
    % use masking curve to quantize MDCT coefficients of block k by
    % dividing by the scale factor and rounding
    % the mdct has a frequency resolution twice as high as the fft
    % we use one scale factor for four consecutive MDCT frequency bins
    
    for m = 1:2:blockLength/2-2
        Y_quant(k,2*m-1) = round(Y_mdct(k,2*m-1)/10^(masking_thresh(m,k)/20));
        Y_quant(k,2*m) = round(Y_mdct(k,2*m)/10^(masking_thresh(m,k)/20));
        Y_quant(k,2*m+1) = round(Y_mdct(k,2*m+1)/10^(masking_thresh(m,k)/20));
        Y_quant(k,2*m+2) = round(Y_mdct(k,2*m+2)/10^(masking_thresh(m,k)/20));
    end
           
end