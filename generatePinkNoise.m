function pn = generatePinkNoise( Fs, seconds )

% generate pink noise using Matlab's arbmag
% save to wav file in format 'pinknoise_Fs_seconds.wav' and 'pn.wav'
% 64 bit per sample for reading with Matlab again
% generate two more seconds at beginning and end, but only save middle part

n = 2^16;
f = linspace(0,1,2^12); 
as = ones(size(f));
as(2:length(as)) = 1 ./ sqrt(f(2:length(f)));
as(1) = as(2);
a = as;
d = fdesign.arbmag(n,f,a);
hd1 = design(d,'freqsamp');
fvtool(hd1)

g = randn(1,Fs*(seconds+4)); %AWGN
pn = filter(hd1,g);
disp('pn generated')
pn = pn(2*Fs+1:end-2*Fs);

audiowrite('pn.wav',pn,Fs,'BitsPerSample',64)
audiowrite(['pinknoise_' num2str(Fs) '_' num2str(seconds) '.wav'],pn,Fs,'BitsPerSample',64)