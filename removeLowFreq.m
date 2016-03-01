function [outputPower,outputFrequency] = removeLowFreq(power,frequency,freqLim)

for i = 1:length(power);
    onePower = power{i};
    oneFreq = frequency{i};
    
    freqIndex = oneFreq < freqLim;
    
    onePower(freqIndex) = [];
    oneFreq(freqIndex) = [];
    
    outputPower{i} = onePower;
    outputFrequency{i} = oneFreq;
end

