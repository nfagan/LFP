%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Filter Design and Application (Signal Processing Toolbox)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function LFP = doFilter(plex,Fc)

ad = plex.ad;
adfreq = plex.adfreq;
% Fs=40000; %Sampling rate (Hz)
n=3; %Order of the filter
% [b,a]=butter(n,Fc/Fs); %Create Butterworth Filter

% [b,a] = butter(n,Fc/Fs,'low');
% [b,a] = butter(n,Fc/Fs,'low');

% [b,a] = butter(n,(2*pi*Fc/adfreq),'low');

% [b,a] = butter(n,([2*pi*3/adfreq 2*pi*Fc/adfreq]),'bandpass');
[b,a] = butter(n,2*Fc/adfreq,'low');

LFP=filter(b,a,ad);




