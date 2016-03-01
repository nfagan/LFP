%% 
clear all; clc

%%

%%% Global Script Inputs

% umbrellaDirectory = '/Volumes/My Passport/NICK/Chang Lab 2016/LFP/Olgas_Data/recording data analysis _ olga/';
% umbrellaDirectory = '/Volumes/My Passport/NICK/Chang Lab 2016/LFP/Olgas_Data_reformatted/recording data analysis _ olga/';

dataType = 'Olga ACC'; % 'Olga BLA' | 'Wes BLA'
outcome = 'other'; %'self' | 'both' | 'other' | 'none' | 'pro' | 'anti'
trialType = 'choice'; %all or 'choice' or 'cued'
epoch = 'Reward'; %Target
windowSize = 3500; %ms
stepSize = 10; %ms
lengthToPlot = 10; %ms
initial = -1000; %ms -- use to look backwards
filterCutoff = 250;

doPeriodogramCheck = 0;%for demonstration purposes
loadIn = 1; %test load in portion

if (strcmp(dataType,'Olga BLA')) || ((strcmp(dataType,'Olga ACC')));
    umbrellaDirectory = '/Volumes/My Passport/NICK/Chang Lab 2016/LFP/Olgas_Data_reformatted/recording data analysis _ olga/';
else
    umbrellaDirectory = '/Volumes/My Passport/NICK/Chang Lab 2016/LFP/Wes_data_reformatted/Plex_and_Picto/';
end

%%% Calculations Based on Inputs

folderDirectory = getFolderDirectory(umbrellaDirectory);

numWindows = lengthToPlot/stepSize;

for k = 1:length(folderDirectory); % for looping through DATA FILES
    
    startDirectory = strcat(umbrellaDirectory,folderDirectory(k).name,'/');
    cd(startDirectory);
    
%%% Load + Format Data

if loadIn;   
    [plex,eventData,trialVarData,M] = getDataFiles(startDirectory,dataType,1);  
end

[eventData,trialVarData,M] = cleanUpData(eventData,trialVarData,M);

% eventData = makeMatrix(eventData);
% trialVarData = makeMatrix(trialVarData);

%%% Filter Signal

LFP = doFilter(plex,filterCutoff); %raw signal, filter cutoff

%%% Interpolate values + Create epochs using plexonTime markers

% [allTimes,errorIndex] = getEventTimes2(eventData,M,1);
[allTimes,errorIndex] = getEventTimes3(eventData,M);

%%% Remove Errors

[allTimes,trialVarData] = removeErrorTrials(allTimes,trialVarData,errorIndex); %remove errors first

%%% Separate Trials by Reward Outcome, and optionally by Trial Type

allTimes = epochSort3(trialVarData,allTimes,outcome,trialType);

%%% Get Signal For the Wanted Epoch

for i = 1:numWindows;
    
    if i > 1;
        initial = initial+stepSize;
    end;

allSignals{k,i} = getWantedSignal(LFP,allTimes,epoch,windowSize,initial);

end;

end

%%% Concatenate Across Files

concatenatedSignals = concatenateAcrossFiles(allSignals);

%%

%%% Multitaper

for i = 1:size(concatenatedSignals,2);
    signalPerWindow = concatenatedSignals{i}; %get current time window's signal
    
    [pxx,w] = doMultitaper(signalPerWindow,1);    
    [nonTaperedPower,nonTaperedFreq] = doPeriodogram(signalPerWindow,1);
    
    pxx = changePower(pxx); nonTaperedPower = changePower(nonTaperedPower);
    
    pxx = 10*log10(pxx); %convert to dB
    nonTaperedPower = 10*log10(nonTaperedPower);
    
    power{i} = pxx;
    frequency{i} = w;
    
    power2{i} = nonTaperedPower;
    frequency2{i} = nonTaperedFreq;
    
end

%%% Spectrogram

h = spectrogramOverTime(power,frequency);
% h = spectrogramOverTime(power2,frequency2);
addTickLabels(numWindows,stepSize);

%%% Periodogram / Comparison

if doPeriodogramCheck
    periodogramLFP(power,frequency,concatenatedSignals,1,1);
end;
















    
    
