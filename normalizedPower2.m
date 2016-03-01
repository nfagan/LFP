function [normalizedPower,outputFrequency] = normalizedPower2(wantedEpochSignals,baselineSignals,functionType,takeMean)

if length(wantedEpochSignals) ~= length(baselineSignals);
    for k = 2:length(wantedEpochSignals);
        baselineSignals{k} = baselineSignals{1};
    end
end


fs = 40000;

freqs = 0:2:200;

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
        [pxx,w] = periodogram(oneWindowBaseline,[],freqs,fs);
%         [pxx,w] = periodogram(oneWindowBaseline);
%         w = (w.*fs)./(2*pi); %convert from normalized freq to hz
        
        baselinePower = pxx;
        baselineFreq = w;
        clear pxx w;
        
        %get target power
        [pxx,w] = periodogram(oneWindowTarget,[],freqs,fs);
%         [pxx,w] = periodogram(oneWindowTarget);
%         w = (w.*fs)./(2*pi); %convert from normalized freq to hz        
        
        targetPower = pxx;
        targetFreq = w;
        clear pxx w;
        
    end;
    
    if functionN == 2;
        
        %get multitapered baseline
        
%         [pxx,f] = pmtm(oneWindowBaseline,nw,max(256,2^nextpow2(length(oneWindowTarget))),1000);
%         w = f;
        
        [pxx,w] = pmtm(oneWindowBaseline,nw);
%         pxx = 10*log10(pxx); %convert do dB
        w = (w.*fs)./(2*pi); %convert from normalized freq to hz
        
        baselinePower = pxx;
        baselineFreq = w;
        clear pxx w;
        
        %get multitapered target
%         
%         [pxx,f] = pmtm(oneWindowTarget,nw,max(256,2^nextpow2(length(oneWindowTarget))),1000);
%         w = f;
        
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
        normalizedPowerPerWindow = mean(normalizedPowerPerWindow,2);        
    end
    
    normalizedPower{i} = normalizedPowerPerWindow;
    outputFrequency{i} = targetFreq;
    clear normalizedPowerPerWindow    
    
end
        
        
        
        
        
        
        
        
        
    
    
    
    
    
    
    
   
    
