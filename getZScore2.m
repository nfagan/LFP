function [zScore,outputFreq] = getZScore2(wantedEpochSignals,functionType,takeMean)

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
    oneWindowTarget = wantedEpochSignals{i}';
    
    if functionN == 1;
        
        [pxx,w] = periodogram(oneWindowTarget);        
        w = (w.*fs)./(2*pi); %convert from normalized freq to hz
        
    end
    
    if functionN == 2;
        
        %get multitapered baseline
        [pxx,w] = pmtm(oneWindowTarget,nw);
        w = (w.*fs)./(2*pi); %convert from normalized freq to hz
        
    end
    
    for j = 1:size(pxx,1);
        oneFreqPxx = pxx(j,:);
        zScorePerFreq(:,j) = zscore(oneFreqPxx);
    end
    
%     zScore{i} = zScorePerFreq;
    if takeMean;
        zScore{i} = mean(zScorePerFreq,2);
    else
        zScore{i} = zScorePerFreq';
    end
    outputFreq{i} = w;
    
end
    
        
    
        
        
        