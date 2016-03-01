function normalizedSignal = normalizeSignal(signal,fixationTimes,extractedTimesforWantedEpoch,fixationWindow)

for j = 1:length(extractedTimesforWantedEpoch) %for each trial ...
    %find where in the signal ad the desired epoch begins, and then
    %add to that the window size
    signalDuringWantedEpoch = signal(extractedTimesforWantedEpoch(j):(extractedTimesforWantedEpoch(j)+windowSize));
    
    baselineSignal = signal((fixationTimes(j)-fixationWindow):fixationTimes(j));

end



