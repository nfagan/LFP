%% 

clear all; clc; load NickWorkspace;

%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% global script inputs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

startDirectory = '/Volumes/My Passport/NICK/Chang Lab 2016/LFP/Olgas_Data/recording data analysis _ olga/12012015/';
umbrellaDirectory = '/Volumes/My Passport/NICK/Chang Lab 2016/LFP/Olgas_Data/recording data analysis _ olga/';

dataType = 'Olga ACC';
outcome = 'self'; %'self' | 'both' | 'other' | 'none' | 'pro' | 'anti'
trialType = 'all'; %all or 'choice' or 'cued'
epoch = 2; %Reward
windowSize = 300; %ms
stepSize = 10; %ms

toPlot = 1;%for demonstration purposes

loadIn = 1; %test load in portion

switch trialType
    case 'choice'
        trialType = 1;
    case 'cued'
        trialType = 2;
    case 'all'
        trialType = 0;
end


%reserve 'i' for globally stepping forwards in time; use 'k' for looping
%through data files

for i = 1; %for looping through WINDOWS (global)
    
    if i > 1;
        stepSize = stepSize + 10;
    end
    
    folderDirectory = getFolderDirectory(umbrellaDirectory);

for k = 1:length(folderDirectory); % for looping through DATA FILES (within a time window)
%for k = 1;

startDirectory = strcat(umbrellaDirectory,folderDirectory(k).name,'/');
cd(startDirectory);
clear eventData trialVarData M

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%% Load in Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if loadIn;
    
    if i < 2;
        doPlex = 1;
        [plex,eventData,trialVarData,M] = getDataFiles(startDirectory,dataType,doPlex);
    else
        doPlex = 0;
        [null,eventData,trialVarData,M] = getDataFiles(startDirectory,dataType,doPlex);
    end   
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%% format values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if iscell(eventData);    
    eventData = makeMatrix(eventData);
    trialVarData{1} = makeMatrix(trialVarData);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Filter Design and Application (Signal Processing Toolbox)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ad = plex.ad;
Fs=1000; %Sampling rate (Hz)
n=2; %Order of the filter
Fc=300; %Cutoff Frequency %Range of 70:300
[b,a]=butter(n,Fc/Fs); %Create Butterworth Filter
LFP=filter(b,a,ad);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Interpolate values + Create epochs using plexonTime markers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if strcmp(dataType,'Olga BLA') || strcmp(dataType,'Olga ACC');
    M = fliplr(M);
end

% [storeAllTimesPerBlock,storeErrorIndexPerBlock] = getEventTimes(eventData,M);

[storeAllTimesPerBlock,storeErrorIndexPerBlock] = getEventTimes2(eventData,M);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Separate Trials by Reward Outcome, and optionally by Trial Type
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

allTimes = epochSort2(trialVarData,storeAllTimesPerBlock,storeErrorIndexPerBlock,outcome,trialType);

% if we want, we can separate cued trials from choice trials
% choice = epochSort2(trialVarData,storeAllTimesPerBlock,storeErrorIndexPerBlock,outcome,1);
% cued = epochSort2(trialVarData,storeAllTimesPerBlock,storeErrorIndexPerBlock,outcome,2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get Signal For the Wanted Epoch
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Obtain analogue signal over the specified interval, seperately for each
%outcome

%1 = preFixation; 2: postFixation; 3: magCue; 4: targetOnset; 5:rewardOnset

%INPUTS: analog signal | timing events (in this case, separated by OUTCOME) | 
%the desired epoch on which to set t=0 | the window size (ms) | the step size (ms)

% signalPerOutcomePerBlock = getWantedSignal(ad,separateByOutcomePerBlock,5,300,0);
% allSignalsPerWindow = getWantedSignal(ad,allTimes,epoch,windowSize,0);
allSignalsPerWindow = getWantedSignal(LFP,allTimes,epoch,windowSize,stepSize);

%store each data file's signal output
allSignals{k} = allSignalsPerWindow;

end %end of data files loop

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Concatenate the Data Files For a Given Time Window
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

concatenatedAllSignals = concatenateAllBlocks(allSignals);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Multitaper
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    [pxx,w] = doMultitaper(concatenatedAllSignals,1);

    extractW = w;
    extractPxx = pxx(:,1);

    if toPlot;

        plot(extractW,10*log10(extractPxx));

        [xdft,freq] = periodogram(concatenatedAllSignals(1,:));

        hold on
        plot(freq,10*log10(xdft),'k');

        xlim([0 3.5]); ylim([-80 0]);
    end

    % store power and frequency data for a given time window
    power{i} = pxx;
    frequency{i} = w;

end % end of WINDOW

%%

hold off;

h = spectrogramOverTime(power,frequency);

