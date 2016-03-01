function removeBandErrors(power,frequency)

for i = 1:length(power)
    oneWindowPower = power{i};
    oneWindowFreq = frequency{i};
    oneWindowFreq(:,2:end) = [];
    
    
    for k = 1:size(oneWindowPower,2);
        toTest = oneWindowPower(:,k);
        
        lateStageMean = mean(toTest((oneWindowFreq>100)&(oneWindowFreq<150)));        
        
        
        if mean(toTest(oneWindowFreq>100)) > toTest
    
    
    
    
    
    
    
    