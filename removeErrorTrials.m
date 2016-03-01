function [fixedEventTimes,fixedTrialVarData] = removeErrorTrials(eventTimes,trialVarData,errorIndex)
    eventTimes(errorIndex,:) = [];
    trialVarData(errorIndex,:) = [];
    
    fixedEventTimes = eventTimes;
    fixedTrialVarData = trialVarData;
    


