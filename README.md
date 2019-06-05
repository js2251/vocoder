# vocoder
A simple and flexible vocoder in Matlab

The vocoder was written to be simple to understand, but also flexible to be adapted.
An example is given in vocode(), which is a function that takes two filenames, one for the input and one for the generated output.

The codoer consists of two main steps:
(1)	Extract envelopes for all channels
(2)	Use this envelope to shape bandpass-filtered noises, pure tones, or many pure tones

Step 1 is implemented in extractAllEnvelopes(), which calls extractEnvelope() for each channel. It consists of a bandpass filter, a half-wave rectifier and a lowpass filter.
For step 2, three strategies are provided:
(a)	Noise vocoder based on pink-noise bands
(b)	Pure tone vocoder: One pure tone for each channel’s centre frequency
(c)	SPIRAL (doi: 10.1121/1.5009602). This vocoder uses many pure-tone carriers which are weighted by distance to the centre frequency of the channel. Note that step 1 differs slightly from the paper.

For strategy (a), a pink noise needs to be generated once with a duration at least 4 seconds longer than any signal to be analysed. This can be done via getPinkNoiseCarrier(), which will generate pn.wav
