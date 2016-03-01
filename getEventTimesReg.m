function [storeAllTimes,storeErrorIndex] = getEventTimesReg(eventData,M)

if iscell(eventData)
    eventData = cell2mat(eventData);
end

plexTime = M(:,1); picTime = M(:,2);
allNeuralEvents = zeros(size(eventData,1),size(eventData,2));

mdl = fitlm(picTime,plexTime);

intercept = table2array(mdl.Coefficients(1,1));
slope = table2array(mdl.Coefficients(2,1));

for k = 1:size(eventData,1);
    oneTrialTime = eventData(k,1);    
    
    if oneTrialTime > 0        
        
        actualNeuralStart = slope*oneTrialTime+intercept;
        
        for j = 2:size(eventData,2);
            toAppend(:,j-1) = eventData(k,j) - eventData(k,1);
        end
        
        toAppend = toAppend+actualNeuralStart;
        
        oneTrialEvents(:,1) = actualNeuralStart;
        oneTrialEvents(:,2:size(eventData,2)) = toAppend;
        
        allNeuralEvents(k,:) = oneTrialEvents;
        
    else
        allNeuralEvents(k,:) = 0;
    end
end;

zerosErrorIndex = sum(allNeuralEvents == 0,2); zerosErrorIndex = zerosErrorIndex ~= 0;
negErrorsIndex = sum(allNeuralEvents < 0,2); negErrorsIndex2 = negErrorsIndex ~=0;
% negErrorsIndex = allNeuralEvents(:,size(eventData,2)) < 0;

allErrors = zerosErrorIndex | negErrorsIndex;

storeAllTimes = allNeuralEvents;
storeErrorIndex = allErrors;

