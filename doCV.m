function [accCV,blaCV,frequency] = doCV(blaSignals,accSignals)

freqs = 0:2:200;
fs = 40000;

for i = 1:length(blaSignals)
    
    oneBLA = blaSignals{i}';
    oneACC = accSignals{i}';    
    
    [blaPower,f] = periodogram(oneBLA,[],freqs,fs);
    [accPower,f] = periodogram(oneACC,[],freqs,fs);
    
    blaDev = std(blaPower,0,2);
    blaMean = mean(blaPower,2);
    
    blaCV(:,i) = blaDev./blaMean;
    
    accDev = std(accPower,0,2);
    accMean = mean(accPower,2);
    accCV(:,i) = accDev./accMean;   
    
    frequency(:,i) = f;
    
end