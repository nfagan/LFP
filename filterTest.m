%%%% Fc/samplingRate*2
cd('/Users/Nick/Music/iTunes/iTunes Music/Wilco/The Whole Love');

[y, Fs] = audioread('01 Art of Almost.wav');
adfreq = Fs;
n = 10;
freq = [2*300/adfreq 2*1000/adfreq];

[b,a] = butter(n,freq,'bandpass');
% [b,a] = cheby1(n,.1,freq);
LFP=filter(b,a,y);
% [b,a] = butter(n,freq(2),'low');
% LFP = filter(b,a,LFP);

cd /Users/Nick/Desktop;
audiowrite('test.wav',LFP,adfreq);

%%

adfreq = plex.adfreq;
LFP = plex.ad;
n = 3;
% freq = [2*250/adfreq 2*1000/adfreq];
% [b,a] = butter(n,freq,'bandpass');

Fc = 250;
FcLow = 10;

freq = [2*Fc/adfreq];
[b,a] = butter(n,freq,'low');
LFP=filter(b,a,LFP);

[b,a] = butter(n,FcLow*2/adfreq,'high');
LFP=filter(b,a,LFP);

cd /Users/Nick/Desktop;
audiowrite('testFiltered2.wav',LFP,adfreq);