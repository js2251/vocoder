function out = ERBnumber2frequency( in )

% convert ERB-number to frequency

out = ( 10 .^ ( in / 21.366 ) - 1 ) / 0.004368;