function periodogramLFP(power,frequency,concatenatedSignals,windowNumber,trialNumber)
    onePower = power{windowNumber};
    oneFrequency = frequency{windowNumber};

    multiPower = onePower(:,trialNumber);
    multiFreq = oneFrequency;
    
    extractForPeriodogram = concatenatedSignals{windowNumber};
    oneTrial = extractForPeriodogram(trialNumber,:);
    
%     [xdft,freq] = periodogram(oneTrial);
    
    windowLength = 1:length(oneTrial);

    [pxx,f] = periodogram(oneTrial,windowLength,windowLength,1000);
    
    hold on
    plot(f,10*log10(pxx),'k');
    plot(multiFreq,multiPower);
    
    
    

    
    
    
    






