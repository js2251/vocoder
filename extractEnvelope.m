function [env, rms_level_band, rms_level_signal] = extractEnvelope(s,Fs,fl,fu,f_cutoff_lp)

% extract the envelope using bandpass-filtering (for channel, or 20-2000 Hz
% hearing range), half-wave rectifying, and low-pass filtering
% bandpass filter: 6-th order Butterworth
% lowpass filter: 3-rd order Butterworth
%
% s: signal
% Fs: sampling rate
% fl: lower limiting frequency of band, default 20 Hz
% fu: upper limiting frequency of band, default 20000 Hz
% f_cutoff_lp: cutoff frequency for half-wave rectified signal, default 50
%
% env: extracted envelope
% rms_level_band: rms level of the band (envelope gets scaled to it)
% rms_level_signal: rms level of the input signal

if nargin < 5
    f_cutoff_lp = 50;
end
if nargin < 3
    fl = 20;
    fu = 20000;
end

rms_level_signal = 20*log10( sqrt(mean(s.*s)) ) + 3;

h    = fdesign.bandpass('N,F3dB1,F3dB2', 6, fl, fu, Fs);
bp   = design(h, 'butter');
sbp  = filter(bp,s);

rms_level_band = 20*log10( sqrt(mean( sbp.*sbp ) ) ) + 3;

g = sbp .* (sbp>0);
h  = fdesign.lowpass('N,F3dB', 3, f_cutoff_lp, Fs);
lp = design(h, 'butter');
env = filter(lp,g);

env = env / sqrt(mean(env.*env)) * sqrt(mean( sbp.*sbp ) );
