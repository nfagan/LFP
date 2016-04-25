%if 5th = 0 and 8th = 1 OR 5th = 1 and 8th = 2 -> outcome = self
%if 5th = 1 and 8th = 1 OR 5th = 0 and 8th = 2 -> outcome = both
%if 5th = 2 and 8th = 1 OR 5th = 3 and 8th = 2 -> outcome = other
%if 5th = 3 and 8th = 1 OR 5th = 2 and 8th = 2 -> outcome = none

% FOR EACH BLOCK, return a 1x4 cell array where cell{1} contains the event
% times for each trial in which SELF is rewarded. cell{2} is the same but
% for BOTH-rewarded trials. cell{3} is other. cell{4} is none.

% make separateByChoice 0, 1 or 2
%   0 means choice and cued trials will be combined
%   1 means choice only
%   2 means cue only

function allTimesPerOutcome = epochSort4(trialVarData,allTimes,outcome,trialType)

    switch trialType
        case 'choice'
            separateByChoice = 1;
        case 'cued'
            separateByChoice = 2;
        case 'all'
            separateByChoice = 0;
    end
    
    selfIndex = (trialVarData(:,5) == 0 & ...
        trialVarData(:,8) == 1) | ...
        (trialVarData(:,5) == 1 & ...
        trialVarData(:,8) == 2);
    bothIndex = (trialVarData(:,5) == 1 & ...
        trialVarData(:,8) == 1) | ...
        (trialVarData(:,5) == 0 & ...
        trialVarData(:,8) == 2);
    otherIndex = (trialVarData(:,5) == 2 & ...
        trialVarData(:,8) == 1) | ...
        (trialVarData(:,5) == 3 & ...
        trialVarData(:,8) == 2);
    noneIndex = (trialVarData(:,5) == 3 & ...
        trialVarData(:,8) == 1) | ...
        (trialVarData(:,5) == 2 & ...
        trialVarData(:,8) == 2);
    
    if separateByChoice ~= 0 %if separating by choice v. cue ...
        if separateByChoice == 2
            choice = 0;
        elseif separateByChoice == 1
            choice = 1;
        end
    
        choiceIndex = trialVarData(:,2) == choice;
        
        selfIndex = selfIndex & choiceIndex;
        bothIndex = bothIndex & choiceIndex;
        otherIndex = otherIndex & choiceIndex;
        noneIndex = noneIndex & choiceIndex;
    
    end
    
    switch outcome
        case 'all';
            allIndex = selfIndex | bothIndex | otherIndex | noneIndex;
            separateByOutcome = allTimes(allIndex,:);
        case 'self'
            separateByOutcome = allTimes(selfIndex,:);
        case 'both'
            separateByOutcome = allTimes(bothIndex,:);
        case 'other'
            separateByOutcome = allTimes(otherIndex,:);    
        case 'none'
            separateByOutcome = allTimes(noneIndex,:);    
        case 'pro'
            proIndex = bothIndex == 1 | otherIndex == 1;
            separateByOutcome = allTimes(proIndex,:);
        case 'anti'
            antiIndex = selfIndex == 1 | noneIndex == 1;
            separateByOutcome = allTimes(antiIndex,:);
    end
    
    allTimesPerOutcome = separateByOutcome;
