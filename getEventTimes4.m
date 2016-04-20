function [storeAllTimes,storeErrorIndex] = getEventTimes4(eventData,M)

if iscell(eventData)
    eventData = cell2mat(eventData);
end

plexTime = M(:,1); picTime = M(:,2); %get times from M .csv file
allNeuralEvents = zeros(size(eventData,1),size(eventData,2)); %preallocate events var

for k = 1:size(eventData,1); %for each trial ...
    oneTrialTime = eventData(k,1); 
    
    if oneTrialTime > 0 %if the trial isn't an error trial ...
        
        below = find(picTime<oneTrialTime,1,'last'); %find the closest M.csv
                                                     %picto time to the
                                                     %"real" picto time
        pictoDifference = oneTrialTime - picTime(below); %get the difference
        actualNeuralStart = plexTime(below) + pictoDifference; %get corresponding
                                                         %plex time and add
                                                         %the calculated
                                                         %difference
        
        for j = 2:size(eventData,2); %find the difference between each 
                                     %subsequent trial event, and store it to add
                                     %to allNeuralEvents (per trial)
            toAppend(:,j-1) = eventData(k,j) - eventData(k,1);
        end
        
        toAppend = toAppend+actualNeuralStart;
        
        oneTrialEvents(:,1) = actualNeuralStart;
        oneTrialEvents(:,2:size(eventData,2)) = toAppend;
        
        allNeuralEvents(k,:) = oneTrialEvents; %store the per-trial events
        
    else
        allNeuralEvents(k,:) = 0; %otherwise, mark the trial for removal later on
    end
end;

zerosErrorIndex = allNeuralEvents(:,1) == 0 | allNeuralEvents(:,5) == 0;
negErrorsIndex = sum(allNeuralEvents < 0,2); negErrorsIndex = negErrorsIndex >=2;

% zerosErrorIndex = sum(allNeuralEvents == 0,2); zerosErrorIndex = zerosErrorIndex ~= 0;
% negErrorsIndex = sum(allNeuralEvents < 0,2); negErrorsIndex2 = negErrorsIndex ~=0;

allErrors = zerosErrorIndex | negErrorsIndex;

storeAllTimes = allNeuralEvents; %output times and error indices, but don't remove errors just yet
storeErrorIndex = allErrors;

