function envelopes = extractAllEnvelopes(s,Fs,f_cutoff_lp,fc,fl,fu)

% extract envelopes for all channels given by centre frequencies fc
% return matrix envelopes, size n x d with n channels and d samples in the
% signal
%
% s: signal
% Fs: sampling rate
% f_cutoff_lp: cutoff frequency for half-wave rectified signal, default 50
% fc: 1 x n vector of centre frequencies

if nargin < 6
    fl = nan(size(fc));
    fu = nan(size(fc));
    fl(1)       = geomean([ fc(1) * fc(1)/fc(2); fc(1)]);
    fl(2:end)   = geomean([ fc(2:end);fc(1:end-1) ]);
    fu(end)     = geomean([ fc(end) * fc(end)/fc(end-1); fc(end) ]);
    fu(1:end-1) = fl(2:end);
end

assert(length(fc) == length(fl),'Number of lower limiting frequencies must match number of centre frequencies');
assert(length(fc) == length(fl),'Number of upper limiting frequencies must match number of centre frequencies');

num_bands = length(fc);
duration  = length(s);

envelopes = nan(num_bands,duration);

for i = 1:num_bands
    envelopes(i,:) = extractEnvelope(s,Fs,fl(i),fu(i),f_cutoff_lp);
end