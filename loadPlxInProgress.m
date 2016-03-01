clear all; clc; load NickWorkspace;

%% global script inputs

%reserve 'i' for globally stepping forwards in time; use 'k' for looping
%through data files

i = 1; %for looping through WINDOWS (global)
k = 1; % for looping through DATA FILES (within a time window)

%% Load in Data

% get Plexon file
disp('Select .pl2 file')
[filename, segmentPath] = uigetfile( '*.pl2', 'Open file...' );
cd(segmentPath);
[adfreq, n, ts, fn, ad] = plx_ad_v(filename, 'WB01'); %Plexon SDK

%get Picto Event File
disp('Select first Picto Analysis Event file (.e.txt)')
[eventFile, eventPath] = uigetfile( '*.txt', 'Open file...' );
cd(eventPath)
eventData = dlmread(eventFile); 

%Import Picto Analysis Trial Variables file
disp('Select first Picto Trial Variables file (.data.txt)')
[trialVarFile, trialVarPath] = uigetfile( '*.txt', 'Open file...' );
cd(trialVarPath)
trialVarData = dlmread(trialVarFile); 

%Import SQL .csv database file containing alignevents table
disp('Select SQL alignevents file (.csv)')
[alignevent, aligneventPath] = uigetfile( '*.csv', 'Open file...' );
cd(aligneventPath)

M = csvread(alignevent,1,3); %column 1 = Plexon Time; column 2 = Picto time


%% Filter Design and Application (Signal Processing Toolbox)
Fs=1000; %Sampling rate (Hz)
n=2; %Order of the filter
Fc=300; %Cutoff Frequency %Range of 70:300
[b,a]=butter(n,Fc/Fs); %Create Butterworth Filter
LFP=filter(b,a,ad);

%% Interpolate values + Create epochs using plexonTime markers

[storeAllTimesPerBlock,storeErrorIndexPerBlock] = getEventTimes(eventData,M);


%% Separate Trials by Reward Outcome, and optionally by Trial Type

allTimes = epochSort2(trialVarData,storeAllTimesPerBlock,storeErrorIndexPerBlock,'pro',0);

% if we want, we can separate cued trials from choice trials
choice = epochSort2(trialVarData,storeAllTimesPerBlock,storeErrorIndexPerBlock,'pro',1);
cued = epochSort2(trialVarData,storeAllTimesPerBlock,storeErrorIndexPerBlock,'pro',2);


%% Get Signal For the Wanted Epoch

%Obtain analogue signal over the specified interval, seperately for each
%outcome

%1 = preFixation; 2: postFixation; 3: magCue; 4: targetOnset; 5:rewardOnset

%INPUTS: analog signal | timing events (in this case, separated by OUTCOME) | 
%the desired epoch on which to set t=0 | the window size (ms) | the step size (ms)

% signalPerOutcomePerBlock = getWantedSignal(ad,separateByOutcomePerBlock,5,300,0);
allSignalsPerWindow = getWantedSignal(ad,allTimes,5,300,0);

%store each data file's signal output
allSignals{k} = allSignalsPerWindow;

%% Concatenate the Data Files For a Given Time Window

concatenatedAllSignals = concatenateAllBlocks(allSignals);


%% Multitaper

toPlot = 1;%for demonstration purposes

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






