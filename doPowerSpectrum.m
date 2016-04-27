function [power,frequency] = doPowerSpectrum(signals,functionType,takeMean,freqs)

global samplingRate;

fs = samplingRate;

numMultitapers = 5;    
nw = (numMultitapers + 1)/2;

for i = 1:length(signals);
    disp(i);
    oneWindowSignals = signals{i};
    oneWindowSignals = oneWindowSignals';
    
    if strcmp(functionType,'p');
        [pxx,w] = periodogram(oneWindowSignals,[],freqs,fs);
    else           
        [pxx,w] = pmtm(oneWindowSignals,(5/2),freqs,fs);
    end
    
    if takeMean
        pxx = mean(pxx,2);
        power(:,i) = pxx;
        frequency(:,i) = w;
    else
        power{i} = pxx;
        frequency{i} = w;
    end
end
