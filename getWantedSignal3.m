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

function signalDuringWantedEpoch = getWantedSignal3(plex,eventTimes,epoch,windowSize,stepSize)

ad = plex.ad;
times = plex.times;

switch epoch    
    case 'Fixation'
        wantedEpoch = 1;
    case 'Mag Cue'
        wantedEpoch = 2;
    case 'Target On'
        wantedEpoch = 3;
    case 'Reward'
        wantedEpoch = 4;
end;

if nargin < 5 %allow for a stepped-window analysis by adjusting the start time of
              %the epoch; by default this is 0
    stepSize = 0;
end 

%now, get the ad signal associated with that length of time

extractedTimesforWantedEpoch = eventTimes(:,wantedEpoch);

%allow for a stepped-window analysis by adjusting the start time of
%the epoch; by default this is 0

extractedTimesforWantedEpoch = extractedTimesforWantedEpoch(:) + stepSize;

%preallocate signalDuringWantedEpoch

signalDuringWantedEpoch(1:length(extractedTimesforWantedEpoch),1:(windowSize+1)) = 0;

for j = 1:length(extractedTimesforWantedEpoch) %for each trial ...
    %find where in the signal ad the desired epoch begins, and then
    %add to that the window size
    
    currentTime = extractedTimesforWantedEpoch(j);
    
    checkTimes = times;
    checkTimes = abs(currentTime-checkTimes);
    index = checkTimes == min(checkTimes); minLocation = find(index == 1);    
    
    signalDuringWantedEpoch(j,:) = ad(minLocation:(minLocation+windowSize));

end


        

    





