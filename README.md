# AudioCoding

This repository contains a MATLAB demo that demonstrates the basic principles of perceptual audio coding using [MDCT](https://en.wikipedia.org/wiki/Modified_discrete_cosine_transform) transform and [Huffman](https://en.wikipedia.org/wiki/Huffman_coding) coding. The MDCT gets applied to the blocked audio signal via polyphase decomposition matrices. The resulting coefficients get quantized by computing the [auditory masking threshold](https://en.wikipedia.org/wiki/Auditory_masking) and scaling such that the quantization error stays below. The quantized coefficients get then stored using Huffman coding, resulting in a binary file that can be decoded using the Huffman table and inverse scaling coefficients. The resulting binary file is about 15% of the size of the original wave file for the provided examples. Developed during the course work for the Audio Coding lecture at TU Ilmenau, 2012.

The main script `audio_coder_demo.m` calls all successive steps on an example file and produces the decoded output wave. Original and decoded wave files can be found in './data'.

An example masking threshold for the MDCT coefficients for one frame looks like this:
![alt text](https://github.com/mleimeister/AudioCoding/blob/master/images/masking.png "")

Example of original and decoded waveforms:
![alt text](https://github.com/mleimeister/AudioCoding/blob/master/images/waveforms.png "")

### Ressources

[Audio Coding](http://www.tu-ilmenau.de/mt/lehrveranstaltungen/lehre-fuer-master-mt/audio-coding/), lecture course at TU Ilmenau.