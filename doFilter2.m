%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Filter Design and Application (Signal Processing Toolbox)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function LFP = doFilter2(plex,Fc)

ad = plex.ad;
adfreq = plex.adfreq; %sampling rate
n=3; %Order of the filter

% [b,a] = butter(n,2*Fc/adfreq,'low'); %lowpass first %original
[b,a] = butter(n,2*pi*Fc/adfreq,'low'); %lowpass first %higher cutoff
LFP=filter(b,a,ad);

FcLow = 10; %highpass second
[b,a] = butter(n,2*FcLow/adfreq,'high');
LFP=filter(b,a,LFP);




