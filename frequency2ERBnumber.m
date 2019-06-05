function out = frequency2ERBnumber ( in )

% convert frequency to ERB-number

out = 21.366 * log(0.004368 * in + 1) / log(10);