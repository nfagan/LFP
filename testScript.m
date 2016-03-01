%test script
dataType = 'test';

trialInfo.outcome = 'all'; %'self' | 'both' | 'other' | 'none' | 'pro' | 'anti' | 'all'
trialInfo.trialType = 'choice'; %all or 'choice' or 'cued'
trialInfo.epoch = 'Reward'; %Target On %Target Acquire %Fixation %Mag Cue %Reward %Pre-Fixation

windowInfo.windowSize = 0; %ms
windowInfo.stepSize = 0; %ms
windowInfo.lengthToPlot = 6000; %ms
windowInfo.initial = -3000; %ms -- use to look backwards

test = masterGetSignals3(dataType,trialInfo,windowInfo);

doPsth(test,5,10,windowInfo.initial,windowInfo.lengthToPlot)
