tic;

global storePlex; % global variable for pre-processed signals
global storeDataType;
global forceReload;

% dataDir = '/Volumes/My Passport/NICK/Chang Lab 2016/LFP/Olgas_Data_Targac/';
% dataDir = '/Volumes/My Passport/NICK/Chang Lab 2016/LFP/new_data';
dataDir = 'E:\nick_data\reformatted';
% dataDir = 'E:\nick_data\to_fix';

dataType = 'bla:lfp'; % acc:lfp % reference

trialInfo.outcome = 'self'; % 'self' | 'both' | 'other' | 'none' | 'pro' | 'anti' | 'all'
trialInfo.trialType = 'cued'; % all | 'choice' | 'cued'
trialInfo.epoch = 'target on'; % Target On | Target Acquire | Fixation | Mag Cue | Reward

switch trialInfo.epoch
    case 'target on'
        windowInfo.stepSize = 50;
        windowInfo.windowSize = 250; 
        windowInfo.lengthToPlot = 2000;
        windowInfo.initial = -1000;
        targOnSignals = load_signals(dataDir,dataType,trialInfo,windowInfo);
        targetOnSignals = getWindows(targOnSignals,windowInfo.stepSize,windowInfo.windowSize);
        
    case 'fixation'
        windowInfo.stepSize = 50; % ms - amount to step-forwards in sliding window
        windowInfo.windowSize = 250; % ms - "bin size"
        windowInfo.initial = -250; % ms - use to adjust the epoch start-time
        windowInfo.lengthToPlot = 0; % use 0 for fixation baseline -- this is because
                             % the TOTAL amount to plot = lengthToPlot +
                             % windowSize, in order to account for the fact
                             % that the *last* time window must also have data
        fixSignals = load_signals(dataDir,dataType,trialInfo,windowInfo);
        fixationSignals = getWindows(fixSignals,windowInfo.stepSize,windowInfo.windowSize);
    case 'target acquire'
        windowInfo.stepSize = 50;
        windowInfo.windowSize = 250; 
        windowInfo.lengthToPlot = 2000;
        windowInfo.initial = -1000;
        targSignals = load_signals(dataDir,dataType,trialInfo,windowInfo);
        targetAcSignals = getWindows(targSignals,windowInfo.stepSize,windowInfo.windowSize);
end

toc;

 
%% get non-normalized power
[power,frequency] = doPowerSpectrum(targetAcSignals,'p',1,[0:2:200]);
% [power,frequency] = doPowerSpectrum(selfBlaSignals,'p',1,[0:2:200]);
% [power2] = getOneTrialOverTime(power,2);
% [frequency2] = getOneTrialOverTime(frequency,1);

%% get coherence
% [coherence,freq] = doCoherence(blaSignals,accSignals,150,1); %last - takeMean
[coherence,freq] = doCoherence(blaSelf,accSelf,150,1); %last - takeMean
% [basecoherence,basefreq] = doCoherence(blaSelfFix,accSelfFix,150,1); %last - takeMean

%% get normalized coherence
normCoherence = doNormalizedCoherence(coherence,basecoherence);

%% look at coherence trial by trial
%use with non-mean coherence 
% [coherence2] = getOneTrialOverTime(coherence,2);

%% zscore coherence
zScore = zScoreCoherence(coherence);
%% plot coherence

% h = coherenceOverTime(coherence,freq,120,[],0);
h = coherenceOverTime2(targetAcPower,frequency(:,1),200,'clims',[],'yLabel','Normalized Power');
% h = coherenceOverTime(normCoherence,freq,120,[],0);

% h = coherenceOverTime(accCV,frequency,120,[0 3],0);
% h = coherenceOverTime(zScore,freq,120,[0 10],0);

%% normalized power

[targetAcPower,frequency] = normPower(targetOnSignals,fixationSignals,'periodogram');
% [power,frequency] = getZScore(targetSignals,fixationSignals,'periodogram',1);
% [zScore,frequency] = getZScore2(rewardSignals,'multitaper',0);
% [rewardPower,frequency] = normalizedPower(rewardSignals,fixationSignals,'periodogram',1);
% [targetAcPower,frequency] = normalizedPower2(targetAcSignals,fixationSignals,'periodogram',1);
% [targetAcPower,frequency] = normPower(targetAcSignals,fixationSignals,'periodogram');
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
% h = spectrogramOverTime4(targetAcPower,frequency,120,trialNumber,0,10,[-1000 1000],[0 16]); %last = trialByTrial
h = spectrogramOverTime4(newPower,frequency2,120,trialNumber,0,50,[-1000 1000],[.5 1.2]);

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


%% get mean subtracted signal

meanCorrectedBlaSelf = getSubtractedMeanSignal(allBlaSignals,selfBlaSignals);