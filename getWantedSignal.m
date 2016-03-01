%inputs are: analog signal ad; the eventTimes (EITHER per block, separately
%for each outcome OR separately for each outcome, combined across blocks);
%the desired epoch wantedEpoch; the windowSize; the optional normalization
%paramaters norm; the optional stepSize in ms (so you can loop this
%function and continually adjust the start of the window); and 
% (optionally) the amount to look backwards from fixation and forwards from 
% reward. Specify prePost if the wanted epoch is preFixation or postReward
%%%
%%% wantedEpoch can be :
%%% 'Pre-Fixation' | 'Fixation' | 'Mag Cue' | 'Target On' | 'Reward'

function signalDuringWantedEpoch = getWantedSignal(ad,eventTimes,epoch,windowSize,stepSize,prePost)

switch epoch
    case 'Pre-Fixation'
        wantedEpoch = 1;
    case 'Fixation'
        wantedEpoch = 2;
    case 'Mag Cue'
        wantedEpoch = 3;
    case 'Target On'
        wantedEpoch = 4;
    case 'Reward'
        wantedEpoch = 5;
end;

if nargin < 5 %allow for a stepped-window analysis by adjusting the start time of
              %the epoch; by default this is 0
    stepSize = 0;
end 

if nargin > 5 %you don't need to specify prePost UNLESS the wantedEpoch is 
    %before fixation or after reward

preTime = prePost(1); %how many milliseconds pre-fixation to consider (true start time)
postTime = prePost(2); %how many milliseconds post-reward to consider (true end time)

else
    
    preTime = 100; postTime = 100; %default values
    
end

outcomeTimesPrePost(1:size(eventTimes,1),1:(size(eventTimes,2)+2)) = 0;
%create a new Timing variable with preFixation and postReward event times

outcomeTimesPrePost(:,2:(size(eventTimes,2)+1)) = eventTimes; % fill in the other eventTimes

outcomeTimesPrePost(:,1) = eventTimes(:,1) - preTime; %add preFixation
outcomeTimesPrePost(:,end) = eventTimes(:,end) + postTime; %add postReward (end of trial)

%now, get the ad signal associated with that length of time

extractedTimesforWantedEpoch = outcomeTimesPrePost(:,wantedEpoch);

%allow for a stepped-window analysis by adjusting the start time of
%the epoch; by default this is 0

extractedTimesforWantedEpoch = extractedTimesforWantedEpoch(:) + stepSize;

%preallocate signalDuringWantedEpoch

signalDuringWantedEpoch(1:length(extractedTimesforWantedEpoch),1:(windowSize+1)) = 0;

for j = 1:length(extractedTimesforWantedEpoch) %for each trial ...
    %find where in the signal ad the desired epoch begins, and then
    %add to that the window size
    signalDuringWantedEpoch(j,:) = ad(extractedTimesforWantedEpoch(j):(extractedTimesforWantedEpoch(j)+windowSize));

end


        

    





