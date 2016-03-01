function [power,frequency] = doPeriodogram2(concatenatedSignals,takeMean)

for i = 1:size(concatenatedSignals,2);
    
    signalPerWindow = concatenatedSignals{i}; %get current time window's signal
    
    fs = 1000;    
    
    for k = 1:size(signalPerWindow,1);
        
        oneTrialSignal = signalPerWindow(k,:);
    
        %original
        [pxx,w] = periodogram(oneTrialSignal);
        
        pxx = 10*log10(pxx); %convert do dB
        w = (w.*fs)./(2*pi); %convert from normalized freq to hz
        
        storePxxPerTrial(:,k) = pxx;
        storeFreqPerTrial(:,k) = w;
        
    end
    
    if takeMean
        storePxxPerTrial = mean(storePxxPerTrial,2);
        storeFreqPerTrial(:,2:end) = [];
    end
        
    power{i} = storePxxPerTrial;
    frequency{i} = storeFreqPerTrial;

    clear storePxxPerTrial storeFreqPerTrial
    
end