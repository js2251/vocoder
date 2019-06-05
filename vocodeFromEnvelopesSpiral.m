function s = vocodeFromEnvelopesSpiral(fc, envelopes, Fs, rms_level )

% special function for vocoding according to SPIRAL (doi:10.1121/1.5009602)
% only matches a specific implementation of spiral for given envelopes
% full implementation of SPIRAL see supplemental material of the article
% 
% the implementation is carrier-based, rather than the other methods in
% vocodeFromEnvelopes, which are 'electrode-based' when applied to cochlear
% implants
%
% fc: 1 x n vector of centre frequencies
% envelopes: n x d matrix where each row represents the envelope for a
% corresponding center frequency, duration d

fl           = 20;
fu           = 20000;
num_carriers = 160;
spread       = -8; % dB per octave

num_bands    = length(fc);
duration     = size(envelopes,2);

ERB_carrier  = linspace(frequency2ERBnumber(fl),frequency2ERBnumber(fu),num_carriers);
f_carrier    = ERBnumber2frequency( ERB_carrier );

s = zeros(1,duration);

for i = 1:num_carriers
    t             = 1:duration;
    rand_phase    = rand(1) * 2 * pi;
    s_this = sin( t/Fs*2*pi*f_carrier(i) + rand_phase ); 
    for j = 1:num_bands
        s = s + s_this .* envelopes(j,:) * 10^( spread/10 * abs( log2( fc(j) / f_carrier(i) ) ) );
    end
end

s = s / sqrt(mean(s.*s)) / sqrt(2) * 10^(rms_level/20);