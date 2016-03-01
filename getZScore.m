function [zScore,outputFrequency] = getZScore(wantedEpochSignals,baselineSignals,functionType,takeMean)

if length(wantedEpochSignals) ~= length(baselineSignals);
    for k = 2:length(wantedEpochSignals);
        baselineSignals{k} = baselineSignals{1};
    end
end


fs = 1000;

numMultitapers = 5;    
nw = (numMultitapers + 1)/2;

switch functionType
    case 'periodogram'
        functionN = 1;     
    case 'multitaper'
        functionN = 2;        
end

for i = 1:size(wantedEpochSignals,2);
    oneWindowBaseline = baselineSignals{i}';
    oneWindowTarget = wantedEpochSignals{i}';
    
    if functionN == 1;
        
        %get baseline power
        [pxx,w] = periodogram(oneWindowBaseline);        
%         pxx = 10*log10(pxx); %convert do dB
        w = (w.*fs)./(2*pi); %convert from normalized freq to hz
        
        baselinePower = pxx;
        baselineFreq = w;
        clear pxx w;
        
        %get target power
        [pxx,w] = periodogram(oneWindowTarget); 
%         pxx = 10*log10(pxx); %convert do dB
        w = (w.*fs)./(2*pi); %convert from normalized freq to hz        
        
        targetPower = pxx;
        targetFreq = w;
        clear pxx w;
        
    end;
    
    if functionN == 2;
        
        %get multitapered baseline
        [pxx,w] = pmtm(oneWindowBaseline,nw);
%         pxx = 10*log10(pxx); %convert do dB
        w = (w.*fs)./(2*pi); %convert from normalized freq to hz
        
        baselinePower = pxx;
        baselineFreq = w;
        clear pxx w;
        
        %get multitapered target
        [pxx,w] = pmtm(oneWindowTarget,nw);
%         pxx = 10*log10(pxx); %convert do dB
        w = (w.*fs)./(2*pi); %convert from normalized freq to hz
        
        targetPower = pxx;
        targetFreq = w;
        clear pxx w;
        
    end
    
    for j = 1:size(baselinePower,2)
        normalizedPowerPerWindow(:,j) = targetPower(:,j)./baselinePower(:,j);
    end
    
    if takeMean
        
        for k = 1:size(normalizedPowerPerWindow,1)
            oneFreqPowers = normalizedPowerPerWindow(k,:);
            oneFreqZ = zscore(oneFreqPowers);            
            storeZScore(k,:) = mean(oneFreqZ);
            
        end            
        
    end
    
    zScore{i} = storeZScore;
    outputFrequency{i} = targetFreq;
    clear normalizedPowerPerWindow    
    
end
        
        
        
        
        
        
        
        
        
    
    
    
    
    
    
    
   
    
