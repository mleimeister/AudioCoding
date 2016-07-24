% Compression of an audio file using MDCT filter bank, perceptual masking
% threshold and huffman coding. 

clear all;
clc;

% setup
blockLength = 1024;
inputFile = './data/handel.wav';

% read and normalize audio
[x,fs] = wavread(inputFile);
x = x/max(x);

% get size of original file to compare later
original = dir(inputFile);
original_size = original.bytes;

% compute how many blocks are needed and allocate the input block matrix
numBlocks = floor(length(x)/blockLength);
X = zeros(numBlocks, blockLength);

% blocking of the input audio data
for k = 1:numBlocks
    for m = 1:blockLength
        X(k,m) = x((k-1)*blockLength + m);
    end
end

%% Analysis filter bank and quantization

Y_mdct = mdct_analysis(X);
[Y_quant, masking_thresh] = masking_quantization(Y_mdct, X, fs);

% plot one masking curve to get an impression
figure(1);
plot(masking_thresh(:,10), '-r');  
hold on;    
S = 20*log10(abs(fft(X(10,:))));
plot(S(1:blockLength/2));   
legend('Masking threshold', 'FFT spectrum');
xlabel('FFT bin'), ylabel('Amplitude');
hold off;

%% Encode and write bitstream to file

% cell array to hold the huffman dictionaries for the M different blocks
dictionary{numBlocks} = [];

[~, fn, ~] = fileparts(inputFile);
codedFile = ['./data/' fn '_coded'];
fileID = fopen(codedFile,'w');

% vector holding the lengths of the bitstreams for each block, this is
% used for reading out the data later
bitstreamlength = zeros(1,numBlocks);

for m = 1:numBlocks
    % create huffman dictionary of one block of MDCT coefficients
    dictionary{m} = huffman_table(Y_quant(m,:));
    % do the huffman encoding and write to file
    output = huffmanenco(Y_quant(m,:),dictionary{m});
    bitstreamlength(m) = length(output);
    fwrite(fileID, output, 'ubit1');    
end

fclose(fileID);

% compute compression rate

coded = dir(codedFile);
coded_size = coded.bytes;

disp(['The compression rate is ' num2str(coded_size/original_size)]);

%% Read bitstream from file and decode

fileID = fopen(codedFile, 'r');
Y_quant = zeros(numBlocks, blockLength);

for m = 1:numBlocks
    input = fread(fileID, bitstreamlength(m), 'ubit1')';
    Y_quant(m,:) = huffmandeco(input, dictionary{m});
end

fclose(fileID);

%% Dequantization and synthesis filterbank

Y_rescaled = rescale_mdct(Y_quant, masking_thresh);
x_decoded = mdct_synthesis(Y_rescaled);
x_decoded = 0.99 * x_decoded/max(x_decoded);

% write output to wave file
[~, fn, ~] = fileparts(inputFile);
wavwrite(x_decoded, fs, ['./data/' fn '_decoded.wav']);

% compare the waveforms of the original and decoded signal
figure(2), subplot(2,1,1), plot(x), title('Original audio');
subplot(2,1,2), plot(x_decoded), title('Decoded audio');
