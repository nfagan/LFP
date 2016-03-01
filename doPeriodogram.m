function [power,frequency] = doPeriodogram(allSignalsForOneOutcome,takeMean)

allSignalsForOneOutcome = allSignalsForOneOutcome'; %periodogram 
%function treats columns as individual trials; flip input to reflect this

[pxx,f] = periodogram(allSignalsForOneOutcome);

if takeMean
    meanPxx = mean(pxx,2);    
    pxx = meanPxx;
end

frequency = f;
power = pxx;