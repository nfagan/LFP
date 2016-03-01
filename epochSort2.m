%if 5th = 0 and 8th = 1 OR 5th = 1 and 8th = 2 -> outcome = self
%if 5th = 1 and 8th = 1 OR 5th = 0 and 8th = 2 -> outcome = both
%if 5th = 2 and 8th = 1 OR 5th = 3 and 8th = 2 -> outcome = other
%if 5th = 3 and 8th = 1 OR 5th = 2 and 8th = 2 -> outcome = none

% FOR EACH BLOCK, return a 1x4 cell array where cell{1} contains the event
% times for each trial in which SELF is rewarded. cell{2} is the same but
% for BOTH-rewarded trials. cell{3} is other. cell{4} is none.

%make separateByChoice 0, 1 or 2
%   0 means choice and cued trials will be combined
%   1 means choice only
%   2 means cue only

function allTimes = epochSort2(trialVarData,storeAllTimesPerBlock,storeErrorIndexPerBlock,outcome,separateByChoice)

for i = 1:size(storeAllTimesPerBlock,2)
    timesForOneBlock = storeAllTimesPerBlock{i}; %extract event times per block
    trialDataForOneBlock = trialVarData{i}; % extract outcome / other trial data per block
    removeErrorsForOneBlock = storeErrorIndexPerBlock{i}; % get the error index per block
    
    timesForOneBlock(removeErrorsForOneBlock,:) = [];
    trialDataForOneBlock(removeErrorsForOneBlock,:) = [];  
    
    if separateByChoice == 0 %if not separating by choice v. cue ...
    
    selfIndex = (trialDataForOneBlock(:,5) == 0 & ...
        trialDataForOneBlock(:,8) == 1) | ...
        (trialDataForOneBlock(:,5) == 1 & ...
        trialDataForOneBlock(:,8) == 2);
    bothIndex = (trialDataForOneBlock(:,5) == 1 & ...
        trialDataForOneBlock(:,8) == 1) | ...
        (trialDataForOneBlock(:,5) == 0 & ...
        trialDataForOneBlock(:,8) == 2);
    otherIndex = (trialDataForOneBlock(:,5) == 2 & ...
        trialDataForOneBlock(:,8) == 1) | ...
        (trialDataForOneBlock(:,5) == 3 & ...
        trialDataForOneBlock(:,8) == 2);
    noneIndex = (trialDataForOneBlock(:,5) == 3 & ...
        trialDataForOneBlock(:,8) == 1) | ...
        (trialDataForOneBlock(:,5) == 2 & ...
        trialDataForOneBlock(:,8) == 2);
    
    else %return choice only or cue only
        
        if separateByChoice == 2
            choice = 0;
        elseif separateByChoice == 1
            choice = 1;
        end
        
    selfIndex = ((trialDataForOneBlock(:,5) == 0 & ...
        trialDataForOneBlock(:,8) == 1) | ...
        (trialDataForOneBlock(:,5) == 1 & ...
        trialDataForOneBlock(:,8) == 2)) ...
        & (trialDataForOneBlock(:,2) == choice);
    bothIndex = ((trialDataForOneBlock(:,5) == 1 & ...
        trialDataForOneBlock(:,8) == 1) | ...
        (trialDataForOneBlock(:,5) == 0 & ...
        trialDataForOneBlock(:,8) == 2)) ...
        & (trialDataForOneBlock(:,2) == choice);
    otherIndex = ((trialDataForOneBlock(:,5) == 2 & ...
        trialDataForOneBlock(:,8) == 1) | ...
        (trialDataForOneBlock(:,5) == 3 & ...
        trialDataForOneBlock(:,8) == 2))...
        & (trialDataForOneBlock(:,2) == choice);
    noneIndex = ((trialDataForOneBlock(:,5) == 3 & ...
        trialDataForOneBlock(:,8) == 1) | ...
        (trialDataForOneBlock(:,5) == 2 & ...
        trialDataForOneBlock(:,8) == 2))...
        & (trialDataForOneBlock(:,2) == choice);
    
    end
    
    switch outcome
        case 'self'
            separateByOutcome = timesForOneBlock(selfIndex,:);
        case 'both'
            separateByOutcome = timesForOneBlock(bothIndex,:);
        case 'other'
            separateByOutcome = timesForOneBlock(otherIndex,:);    
        case 'none'
            separateByOutcome = timesForOneBlock(noneIndex,:);    
        case 'pro'
            proIndex = bothIndex == 1 | otherIndex == 1;
            separateByOutcome = timesForOneBlock(proIndex,:);
        case 'anti'
            antiIndex = selfIndex == 1 | noneIndex == 1;
            separateByOutcome = timesForOneBlock(antiIndex,:);
    end
    
    separateByOutcomePerBlock{i} = separateByOutcome;
   
    clear separateByOutcome;
end;

allTimes = combineBlocks(separateByOutcomePerBlock);
    
