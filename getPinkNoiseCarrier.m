function s = getPinkNoiseCarrier( fl, fu, duration, Fs )

% get a band-pass filetered pink noise with edge frequencies fl and fu,
% duration samples at sample frequency Fs
% filter used is a 6-th order Butterworth bandpass

h    = fdesign.bandpass('N,F3dB1,F3dB2', 6, fl, fu, Fs);
bp   = design(h, 'butter');
pn   = audioread('pn.wav');
pn   = pn(1:duration+4*Fs);

s    = filter(bp,pn);
s    = s(2*Fs+1:2*Fs+duration);
