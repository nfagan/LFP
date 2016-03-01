function [outputPower,outputFrequency] = getMeanPower(power,frequency)

for i = 1:length(power)
    oneWindowPower = power{i};
    oneWindowFreq = frequency{i};
    meanOneWindow = mean(oneWindowPower,2);
    
    outputPower{i} = meanOneWindow;
    outputFrequency{i} = oneWindowFreq(:,1);
end

    
    