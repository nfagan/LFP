function [storeAllTimes,storeErrorIndex] = getEventTimes2(eventData,M,treatDupAsError)

if iscell(eventData)
    eventData = cell2mat(eventData);
end

plexTime = M(:,1); picTime = M(:,2);

for k = 1:size(eventData,1);
    oneTrialTime = eventData(k,1);    
    testDuplicate = checkIfDuplicateRange(picTime,oneTrialTime);
    
    if oneTrialTime > 0
        if treatDupAsError && testDuplicate
            eventNeural(k) = 0;
        else  
        
        belowX = find(picTime<oneTrialTime, 1, 'last' ); % find closest picto-value below targetValue
        aboveX = find(picTime>oneTrialTime, 1 ); % find closest picto-value above targetValue
        belowY = picTime(belowX); aboveY = picTime(aboveX);

        eventBehX = 1 / ((aboveY-belowY) / (oneTrialTime-belowY)) + belowX;
        eventNeuralX(k) = (plexTime(aboveX)-plexTime(belowX)) * (eventBehX-belowX) + plexTime(belowX);
        
        end
        
    else
        eventNeuralX(k) = 0;
    end
end;

plexonTime=round(eventNeuralX*1000);
plexonTime = plexonTime';

for i = 1:size(eventData,1);
    for k = 1:(size(eventData,2)-1)
        plusTime(i,k) = eventData(i,k+1) - eventData(i,1);
    end;
end;

plusTime = round(plusTime*1000);

for i = 1:size(plusTime,2)
    plexonTime(:,i+1) = plexonTime(:,1) + plusTime(:,i);
end;

errorIndex = plusTime <= 0; errorIndex = sum(errorIndex,2); %plusTime errors
errorIndex = logical(errorIndex ~= 0);

plexErrors = plexonTime(:,1) == 0; %plexonTime errors
allErrors = plexErrors | errorIndex;

storeAllTimes = plexonTime;
storeErrorIndex = allErrors;


