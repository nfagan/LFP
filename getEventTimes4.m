function [storeAllTimes,storeErrorIndex] = getEventTimes4(eventData,M)

if iscell(eventData)
    eventData = cell2mat(eventData);
end

plexTime = M(:,1); picTime = M(:,2);
allNeuralEvents = zeros(size(eventData,1),size(eventData,2));

for k = 1:size(eventData,1);
    oneTrialTime = eventData(k,1);    
    
    if oneTrialTime > 0          
        
        below = find(picTime<oneTrialTime,1,'last');        
        pictoDifference = oneTrialTime - picTime(below);        
        actualNeuralStart = plexTime(below) + pictoDifference;
        
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

zerosErrorIndex = allNeuralEvents(:,1) == 0 | allNeuralEvents(:,5) == 0;
negErrorsIndex = sum(allNeuralEvents < 0,2); negErrorsIndex = negErrorsIndex >=2;

% zerosErrorIndex = sum(allNeuralEvents == 0,2); zerosErrorIndex = zerosErrorIndex ~= 0;
% negErrorsIndex = sum(allNeuralEvents < 0,2); negErrorsIndex2 = negErrorsIndex ~=0;

allErrors = zerosErrorIndex | negErrorsIndex;

storeAllTimes = allNeuralEvents;
storeErrorIndex = allErrors;

