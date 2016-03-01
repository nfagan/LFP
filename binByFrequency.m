function [newPower,newFrequency] = binByFrequency(power,frequency,binFreq)

for i = 1:length(power);
    onePower = power{i};
    oneFreq = frequency{i};   
    
    freqSize = oneFreq(2) - oneFreq(1);
    stepSize = round(binFreq/freqSize);    
    
    toBin = 1:stepSize:length(onePower);
    toBin(end+1) = length(oneFreq);
    
    for j = 1:length(toBin)-1;
        meanPower(j) = mean(onePower(j:j+1,:));        
    end
    
    freq = oneFreq(toBin);
    freq(end) = [];
    
    newPower{i} = meanPower';
    newFrequency{i} = freq;
    
end
    
    



