clear all; close all; format compact; format long;
%% Plexon SDK approach for reading in Plexon data file
% *In .plx files 'WB01' is channel 0. In .pl2 files 'WB01' is channel 1.*
addpath ('E:\MatlabOfflineFilesSDK')
disp('Select .pl2 file')
[filename, segmentPath] = uigetfile( '*.pl2', 'Open file...' );
cd(segmentPath);
[adfreq, n, ts, fn, ad] = plx_ad_v(filename, 'WB01'); %Plexon SDK

%% Filter Design and Application (Signal Processing Toolbox)
Fs=1000; %Sampling rate (Hz)
n=2; %Order of the filter
Fc=300; %Cutoff Frequency %Range of 70:300
[b,a]=butter(n,Fc/Fs); %Create Butterworth Filter
LFP=filter(b,a,ad);

%% Import Picto Analysis files and SQL alignevents table
disp('Select first Picto Analysis Event file (.e.txt)')
[eventFile, eventPath] = uigetfile( '*.txt', 'Open file...' );
cd(eventPath)
eventData = dlmread(eventFile); %#ok<*SAGROW>

%Import Picto Analysis Trial Variables file
disp('Select first Picto Trial Variables file (.data.txt)')
[trialVarFile, trialVarPath] = uigetfile( '*.txt', 'Open file...' );
cd(trialVarPath)
trialVarData = dlmread(trialVarFile); %#ok<*SAGROW>

%Import SQL .csv database file containing alignevents table
disp('Select SQL alignevents file (.csv)')
[alignevent, aligneventPath] = uigetfile( '*.csv', 'Open file...' );
cd(aligneventPath)
M = csvread(alignevent,1,3); %column 1 = Plexon Time; column 2 = Picto time

    
%% Interpolate values + Create epochs using plexonTime markers

% interpolate / get event times for each epoch

[storeAllTimesPerBlock,storeErrorIndexPerBlock] = getEventTimes(eventData,M);


%% Organize data by Trial Type

separateByOutcomePerBlock = epochSort2(trialVarData,storeAllTimesPerBlock,storeErrorIndexPerBlock,0);

%if we want, we can separate into choice and cued
% choice = epochSort2(trialVarData,storeAllTimesPerBlock,storeErrorIndexPerBlock,1);
% cued = epochSort2(trialVarData,storeAllTimesPerBlock,storeErrorIndexPerBlock,2);

allBlocksByOutcome = combineBlocks(separateByOutcomePerBlock);



%% Get Signal For the Wanted Epoch

%Obtain analogue signal over the specified interval, seperately for each
%outcome


signalPerOutcomePerBlock = getWantedSignal(ad,separateByOutcomePerBlock,2,100);
signalPerOutcomeAllBlocks = getWantedSignal(ad,allBlocksByOutcome,2,100);



%% Time Frequency Spectrum Analysis






%% Coherency Analysis




