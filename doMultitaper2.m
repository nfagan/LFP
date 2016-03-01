function [power,frequency] = doMultitaper2(concatenatedSignals,takeMean)

for i = 1:size(concatenatedSignals,2);
    
    signalPerWindow = concatenatedSignals{i}; %get current time window's signal
    
    freqs = 0:10:250;
    fs = 1000;    
    numMultitapers = 5;    
    nw = (numMultitapers + 1)/2;
    
    for k = 1:size(signalPerWindow,1);
        
        oneTrialSignal = signalPerWindow(k,:);
        
%         [pxx,f] = pmtm(oneTrialSignal,nw,freqs,fs); 
        
        %original
        [pxx,w] = pmtm(oneTrialSignal,nw);
        
        pxx = 10*log10(pxx);
        w = (w.*fs)./(2*pi); %convert from normalized freq to hz
        
        storePxxPerTrial(:,k) = pxx;
        storeFreqPerTrial(:,k) = w;
%         storeFreqPerTrial(:,k) = f;
        
    end
    
    if takeMean
        storePxxPerTrial = mean(storePxxPerTrial,2);
        storeFreqPerTrial(:,2:end) = [];
    end
        
    power{i} = storePxxPerTrial;
    frequency{i} = storeFreqPerTrial;

    clear storePxxPerTrial storeFreqPerTrial
    
end


