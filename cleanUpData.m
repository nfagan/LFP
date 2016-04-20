function [eventDataOutput,trialVarDataOutput,mOutput] = cleanUpData(eventData,trialVarData,M)

eventDataOutput = makeMatrix(eventData);
trialVarDataOutput = makeMatrix(trialVarData);

if size(M,2) > 2; % if M has more info than just event times
    mOutput = [M(:,4) M(:,5)];
else
    mOutput = M;
end

% checkOrder = mOutput(1,2) / mOutput(1,1);
% 
% modCheck = mod(M(1,2),1) == 0;
% 
% if checkOrder > 1 || modCheck %if Plexon time is the second column (which it shouldn't be)
%     mOutput = fliplr(mOutput);
% end











