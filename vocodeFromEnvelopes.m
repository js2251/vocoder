function s = vocodeFromEnvelopes(fc, envelopes, carrier_type, Fs, rms_level, fl, fu)

% generate a vocoded signal based on envelopes
% supports two different vocoding strategies:
% (1) based on bands of pink noise (carrier_type: pink)
% (2) based on pure tones (carrier_type: sine)
%
% fc: 1 x n vector of centre frequencies
% envelopes: n x d matrix where each row represents the envelope for a
% corresponding center frequency, duration d
% carrier_type: string and determines the sub-function to generate the
% carriers for each band
% Fs: sampling frequency
% rms_level: rms level of the output in dB relative to a full-scale sinusoid
% fl and fu: lower and upper limiting frequencies of the bands. Geometric
% means are taken if not passed

assert( size(envelopes,1) == length(fc), 'Number of centre frequencies does not match number of envelope channels' );

num_bands = length(fc);
duration  = size(envelopes,2);
carriers  = nan(size(envelopes));

if nargin < 6
    fl = nan(size(fc));
    fu = nan(size(fc));
    fl(1)       = geomean([ fc(1) * fc(1)/fc(2); fc(1)]);
    fl(2:end)   = geomean([ fc(2:end);fc(1:end-1) ]);
    fu(end)     = geomean([ fc(end) * fc(end)/fc(end-1); fc(end) ]);
    fu(1:end-1) = fl(2:end);
end

for i = 1:num_bands
    if strcmp(carrier_type,'noise') || strcmp(carrier_type,'pn') || strcmp(carrier_type,'pink') || strcmp(carrier_type,'pink_noise') || strcmp(carrier_type,'pinknoise')
        carriers(i,:) = getPinkNoiseCarrier( fl(i), fu(i), duration, Fs );
    elseif strcmp(carrier_type,'sine') || strcmp(carrier_type,'sin') || strcmp(carrier_type,'cosine') || strcmp(carrier_type,'cose') ||strcmp(carrier_type,'pt') || strcmp(carrier_type,'pure_tone') || strcmp(carrier_type,'puretone')
        t             = 1:duration;
        rand_phase    = rand(1) * 2 * pi;
        carriers(i,:) = sin( t/Fs*2*pi*fc(i) + rand_phase );   
    else
        error('unknown carrier_type');
    end
end

s = sum( carriers .* envelopes ); 
s = s / sqrt(mean(s.*s)) / sqrt(2) * 10^(rms_level/20);