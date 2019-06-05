function vocode( filename_in, filename_out )

% wrapper function for extractAllEnvelopes and vocodeFromEnvelopes with
% some example parameters (resulting in a noise vocoder with 26 3-rd
% octave bands)
% additionally reads a wav file, and stores vocoded signal to another one
% also generates a high-quality pink noise (computationally expensive),
% from which the noise bands are formed
% to save computation time, only call getPinkNoiseCarrier once with
% sufficient length (at least 4 seconds longer than the longest signal)

f_cutoff_lp  = 50;
fc           = 2.^( -13/3:1/3:12/3 ) * 1000; % 26 channels, 1/3 octaves from 50 Hz to 16 kHz
carrier_type = 'pink';

[s,Fs]    = audioread( filename_in );
rms_level = 20*log10( sqrt(mean(s.*s)) ) + 3;

%generatePinkNoise( Fs, length(s)/Fs+4 ); % run only once with duration based on longest signal to be vocoded (at least 4 sec longer)

envelopes = extractAllEnvelopes(s,Fs,f_cutoff_lp,fc);

s_vocoded = vocodeFromEnvelopes(fc, envelopes, carrier_type, Fs, rms_level);
% s_vocoded = vocodeFromEnvelopesSpiral(fc, envelopes, Fs, rms_level );

audiowrite(filename_out,s_vocoded,Fs,'BitsPerSample',16);


