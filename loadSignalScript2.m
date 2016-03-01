dataType = 'Olga BLA'; % 'Olga BLA' | 'Wes BLA'

trialInfo.outcome = 'all'; %'self' | 'both' | 'other' | 'none' | 'pro' | 'anti' | 'all'
trialInfo.trialType = 'choice'; %all or 'choice' or 'cued'
trialInfo.epoch = 'Target Acquire'; %Target On %Target Acquire %Fixation %Mag Cue %Reward %Pre-Fixation

windowInfo.windowSize = 250; %ms
windowInfo.stepSize = 50; %ms
windowInfo.lengthToPlot = 2000; %ms
windowInfo.initial = -1000; %ms -- use to look backwards

switch trialInfo.epoch;
    case 'Fixation'
        fixationSignals = masterGetSignals3(dataType,trialInfo,windowInfo);
    case 'Target Acquire'
        targetAcSignals = masterGetSignals3(dataType,trialInfo,windowInfo);
end

if strcmp(dataType,'Olga ACC');
    accSignals = getWindows(targetAcSignals,windowInfo.stepSize,windowInfo.windowSize);
else
    blaSignals = getWindows(targetAcSignals,windowInfo.stepSize,windowInfo.windowSize);
end

fprintf('\n \n Saving...');
cd('/Volumes/My Passport/NICK/Chang Lab 2016/LFP/Spectrogram_data/target_acquire');
% cd('/Volumes/My Passport/NICK/Chang Lab 2016/LFP/Coherence_data');
% clearvars -except fixationSignals rewardSignals targetAcSignals accSignals blaSignals allSignals;
% save TWO_DAYS_BLA_SELF_TARG_AC.mat
fprintf('\n \t Done');

%% get mean subtracted signal

accSignals2 = getSubtractedMeanSignal(allSignals,accSignals);
 
%% get non-normalized power

[power,frequency] = doPowerSpectrum(blaSignals2,'p',1);
% [power2] = getOneTrialOverTime(power,2);
% [frequency2] = getOneTrialOverTime(frequency,1);

%% get coherence

% [coherence,freq] = doCoherence(blaSignals,accSignals,150,1); %last - takeMean
[coherence,freq] = doCoherence(blaMeanCorrected,accMeanCorrected,150,1); %last - takeMean

%% look at coherence trial by trial

%use with non-mean coherence 

% [coherence2] = getOneTrialOverTime(coherence,2);


%% zscore coherence

zScore = zScoreCoherence(coherence);

%% plot coherence

% h = coherenceOverTime(coherence,freq,120,[],0);
h = coherenceOverTime(power,frequency,120,[],0);
% h = coherenceOverTime(accPower,frequency,120,[],0);

% h = coherenceOverTime(accCV,frequency,120,[0 3],0);
% h = coherenceOverTime(zScore,freq,120,[0 10],0);

%% normalized power

% [power,frequency] = getZScore(targetSignals,fixationSignals,'periodogram',1);
% [zScore,frequency] = getZScore2(rewardSignals,'multitaper',0);
% [rewardPower,frequency] = normalizedPower(rewardSignals,fixationSignals,'periodogram',1);
[targetAcPower,frequency] = normalizedPower2(targetAcSignals,fixationSignals,'periodogram',1);
% [rewardPowerTrialByTrialPeriodogram,frequency] = normalizedPower(rewardSignalsPeriodogram,fixationSignalsPeriodogram,'periodogram',0);

%% multitaper or periodogram power estimates

[taperedPower,taperedFrequency] = doMultitaper2(concatenatedSignals,0);
[power,frequency] = doPeriodogram2(concatenatedSignals,0);

[meanTaperedPower,meanTaperedFreq] = getMeanPower(taperedPower,taperedFrequency);
[meanPower,meanFreq] = getMeanPower(rewardPowerTrialByTrial,frequency);


%% plot frequency v. power traces
%trial 9,12 BLA 0-500ms post target

means = 1;
% look at trial 20 for good example;

trialN = 100;
% trialN = trialN+1;

if ~means
    h = plotFreqPower(rewardPower,frequency,1,trialN,[0 100]); %power,frequency,windowN,trialN,freqLimits
%     hold on;
%     h = plotFreqPower(taperedPower,taperedFrequency,100,trialN,[0 200]);
else
%     h = plotFreqPower(meanPower,meanFreq,1,trialN,[0 200]); %power,frequency,windowN,trialN,freqLimits
    hold on;
%     h = plotFreqPower(meanTaperedPower,meanTaperedFreq,1,trialN,[0 100]);
%   h = plotFreqPower(rewardPowerTrialByTrial,frequency,1,trialN,[0 100]);
  h = plotFreqPower(rewardPower,frequency,12,1,[0 100]);
end

%means


%% spectrogram
%trial 25,28,50*
% trialNumber = 10;

% set(gcf,'visible','on')

% [rewardPower2,frequency2] = removeLowFreq(rewardPower,frequency,5);
% [rewardPower2,frequency2] = binByFrequency(rewardPower2,frequency2,5);

% cd /Users/Nick/Desktop/FIGURE_OUTPUT/Spectrogram/targ;
trialNumber = 1;
% for i = 1:size(zScore{1},2)-1;
%     
    trialNumber = trialNumber+1;

% h = spectrogramOverTime3(rewardPower,frequency,100,11,1); %last = trialByTrial
% h = spectrogramOverTime4(rewardPower,frequency,120,trialNumber,0); %last = trialByTrial
h = spectrogramOverTime4(targetAcPower,frequency,120,trialNumber,0,10,[0 200]); %last = trialByTrial

% end

% h = spectrogramOneTrial(rewardPowerTrialByTrial,frequency,50,100);
%power,frequency,frequencyCutoff
% h = spectrogramOverTime2(power,frequency,100);
% h = spectrogramOverTime3(targetPowerPeriodogram,frequency,100,trialNumber);
% h = spectrogramOverTime3(targetPowerTrialByTrial,frequency,100,trialNumber);

% h = spectrogramOverTime2(power,frequency,200);
% h = spectrogramOverTime2(taperedPower,taperedFrequency);
% h = spectrogramOverTime2(meanTaperedPower,meanTaperedFreq,20);
% h = spectrogramOverTime2(meanPower,meanFreq,120);
% h = spectrogramOneTrial(taperedPower,taperedFrequency,20);
