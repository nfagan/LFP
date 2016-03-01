function [storeAllTimesPerBlock,storeErrorIndexPerBlock] = getEventTimes(eventData,M)

plexTime = M(:,1); picTime = M(:,2);

for i = 1:length(eventData);
    extractedEvent = eventData{i};
    for k = 1:size(extractedEvent,1);
        if extractedEvent(k) > 0
            
            eventBehTime = extractedEvent(k);
            
            belowX = find(picTime<eventBehTime, 1, 'last' ); % find closest X-value below targetValue
            aboveX = find(picTime>eventBehTime, 1 ); % find closest X-value above targetValue
            belowY = picTime(belowX); aboveY = picTime(aboveX);
                 
            eventBehX = 1 / ((aboveY-belowY) / (eventBehTime-belowY)) + belowX;
            eventNeuralX(i,k) = (plexTime(aboveX)-plexTime(belowX)) * (eventBehX-belowX) + plexTime(belowX);
        else
            eventNeuralX(i,k) = 0;
        end
    end
clear extractedEvent
end


plexonTime=round(eventNeuralX*1000);
plexonTime = plexonTime';

for i = 1:size(plexonTime,2);
    extractedEventData = eventData{i}; %extract one block
    
    extractedPlex = plexonTime(plexonTime(:,i) ~= 0); %extract only non-zero (non-error) start times for this block    
    
    for k = 1:size(extractedPlex,1); %for 1 : how ever many trials are in the block ...
        for j = 1:size(extractedEventData,2)-1; % for 1 : the number of eventTimes (probably 4, but can be however many)
            plusTime(k,j) = extractedEventData(k,j+1) - extractedEventData(k,1); %plusTime, i.e., 
                                                                                 % the amount of time to add to the start time
        end
    end    
    
    removeZerosIndex = logical(sum((plusTime < 0),2)); %find error trials
%     plusTime(removeZerosIndex,:) = []; % remove errors from additional times
%     extractedPlex(removeZerosIndex,:) = []; % remove errors from extracted times
    
    plusTime = plusTime*1000; %format values
    
    for kk = 1:size(plusTime,1);
        plusTime(kk,:) = plusTime(kk,:) + extractedPlex(kk); %now, per trial, add the plusTime values to the start time
    end;
    
    plusTime = round(plusTime); %round to get a whole number (index for 'ad')
    
    storeAllTimes(:,1) = extractedPlex(:); %first column is just start time (fixation)
    storeAllTimes(:,2:size(plusTime,2)+1) = plusTime; %second through [how ever many event times] columns = other event times
    
    storeAllTimesPerBlock{i} = storeAllTimes; %store the times per block
    storeErrorIndexPerBlock{i} = removeZerosIndex; %store error index per block
    
    clear extractedEventData removeZerosIndex plusTime storeAllTimes ...
        removeZerosIndex extractedPlex;
end;











            
    
    


        