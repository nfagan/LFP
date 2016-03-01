function LFP = zeroPhaseFilter(plex,Fc,FcLow)

ad = plex.ad;
adfreq = plex.adfreq; %sampling rate
n=3; %Order of the filter

f1 = 2*FcLow/adfreq;
f2 = 2*pi*Fc/adfreq;

[b,a] = butter(n,[f1 f2]);
LFP=filtfilt(b,a,ad);

% [b,a] = butter(14,2*FcLow/adfreq,'high');
% % LFP=filter(b,a,LFP);
% 
% LFP = filtfilt(b,a,LFP);