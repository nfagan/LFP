%inputs are: analog signal ad; the eventTimes (EITHER per block, separately
%for each outcome OR separately for each outcome, combined across blocks);
%the desired epoch wantedEpoch; the windowSize; the optional normalization
%paramaters norm; the optional stepSize in ms (so you can loop this
%function and continually adjust the start of the window); and 
% (optionally) the amount to look backwards from fixation and forwards from 
% reward. Specify prePost if the wanted epoch is preFixation or postReward
%%%
%%% wantedEpoch can be :
%%% 'Fixation' | 'Mag Cue' | 'Target On' | 'Reward'

function [signalDuringWantedEpoch,saveIndex] = getWantedSignalTargAc(plex,eventTimes,epoch,lengthToPlot,windowSize,initial)

windowSize = windowSize/1000;
initial = initial/1000; %adjust the start time of the epoch
times = plex.idTimes;
ad = plex.ad;

meanCorrect = 0;
meanPlex = mean(ad); stdPlex = std(ad);

multiplier = plex.adfreq/1000;

switch epoch    
    case 'Fixation'
        wantedEpoch = 1;
    case 'Mag Cue'
        wantedEpoch = 2;
    case 'Target On'
        wantedEpoch = 3;
    case 'Target Acquire'
        wantedEpoch = 4;
    case 'Reward'
        wantedEpoch = 5;
end;

%now, get the ad signal associated with that length of time

extractedTimesforWantedEpoch = eventTimes(:,wantedEpoch);

%adjust the start time of the epoch

extractedTimesforWantedEpoch = extractedTimesforWantedEpoch(:) + initial;

%adjust the start time so that it is in the center of the window

% extractedTimesforWantedEpoch = extractedTimesforWantedEpoch(:) - windowSize/2;

%preallocate signalDuringWantedEpoch

signalDuringWantedEpoch(1:length(extractedTimesforWantedEpoch),1:(lengthToPlot*multiplier+1)) = 0;
errorCheck = zeros(length(extractedTimesforWantedEpoch)); %preallocate

for j = 1:length(extractedTimesforWantedEpoch) %for each trial ...
    %find where in the signal ad the desired epoch begins, and then
    %add to that the window size    
    
    basestr = sprintf('\n\t\t %d of %d',j,length(extractedTimesforWantedEpoch));
    fprintf(basestr);
    
    currentTime = extractedTimesforWantedEpoch(j);
    [N,index] = histc(currentTime,times); clear N;
    check = abs(currentTime - times(index)) < abs(currentTime-times(index+1));
    if ~check
        index = index+1;    
    end     
    
    if index+lengthToPlot*multiplier < length(ad);    
        signalDuringWantedEpoch(j,:) = ad(index:index+(lengthToPlot*multiplier));
        errorCheck(j) = 0;        
        
        if meanCorrect            
            replaceSignal = signalDuringWantedEpoch(j,:);
            replaceSignal = (replaceSignal - meanPlex)./stdPlex;
            signalDuringWantedEpoch(j,:) = replaceSignal;
        end        
        
    else        
        signalDuringWantedEpoch(j,:) = NaN;
        errorCheck(j) = 1;        
    end   
    
    saveIndex(j) = index;
    
    if j < length(extractedTimesforWantedEpoch)
        toDel = repmat('\b',1,length(basestr));
        fprintf(toDel);
    end    
end

errorCheck = logical(errorCheck);
signalDuringWantedEpoch(errorCheck,:) = [];


        

    





