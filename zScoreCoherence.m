function zScore = zScoreCoherence(coherence)

if ~iscell(coherence);
    error('Coherence cannot be a mean');
    return;
end


% for i = 1:length(coherence);
%     oneCoherence = coherence{i};
%     
%     zScoreTest = zscore(oneCoherence);
%     zScoreTest = mean(zScoreTest,2);
%     
%     zScore(:,i) = zScoreTest;
% end;
    
%%% pesaran method

for i = 1:length(coherence)
    oneCoherence = coherence{i};
    numTapers = 5;
    numTrials = size(oneCoherence,2);

    v = numTapers*numTrials;

    q = sqrt(-(v-2).*log(1-(abs(oneCoherence.^2))));

    zScoreInterm = 1.5.*(q-1.5);
    zScore(:,i) = mean(zScoreInterm,2);      

end