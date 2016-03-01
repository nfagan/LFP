function [outputCoherence] = getOneTrialOverTime(coherence,trialNum)

for i = 1:length(coherence);
    oneCoherence = coherence{i};
    outputCoherence(:,i) = oneCoherence(:,trialNum);
end

    