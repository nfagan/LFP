function [storeAllTimes,storeErrorIndex] = getEventTimes3(eventData,M)

if iscell(eventData)
    eventData = cell2mat(eventData);
end

plexTime = M(:,1); picTime = M(:,2);
allNeuralEvents = zeros(size(eventData,1),4);

for k = 1:size(eventData,1);
    oneTrialTime = eventData(k,1);    
    
    if oneTrialTime > 0          
        
        below = find(picTime<oneTrialTime,1,'last');        
        pictoDifference = oneTrialTime - picTime(below);        
%         actualNeuralStart = round((plexTime(below)+pictoDifference)*1000);
        actualNeuralStart = plexTime(below) + pictoDifference;
        
        for j = 2:4;
            toAppend(:,j-1) = eventData(k,j) - eventData(k,1);
        end
        
%         toAppend = round(toAppend.*1000+actualNeuralStart);
        toAppend = toAppend+actualNeuralStart;
        
        oneTrialEvents(:,1) = actualNeuralStart;
        oneTrialEvents(:,2:4) = toAppend;
        oneTrialEvents = round(oneTrialEvents*1000);
        
%         allNeuralEvents(k,1) = actualNeuralStart;
%         allNeuralEvents(k,2:4) = toAppend;
%         allNeuralEvents = round(allNeuralEvents*1000);
        
        allNeuralEvents(k,:) = oneTrialEvents;
        
    else
        allNeuralEvents(k,:) = 0;
    end
end;


zerosErrorIndex = sum(allNeuralEvents == 0,2); zerosErrorIndex = zerosErrorIndex ~= 0;
negErrorsIndex = allNeuralEvents(:,4) < 0;

allErrors = zerosErrorIndex | negErrorsIndex;

storeAllTimes = allNeuralEvents;
storeErrorIndex = allErrors;

