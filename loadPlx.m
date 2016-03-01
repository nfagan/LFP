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
% Specify the folder containing all Picto data
disp('Select folder containing Picto Analysis files')
topDir=uigetdir;
cd(topDir);
folders = struct2cell(dir(topDir));
folders = folders(1,3:length(folders)); %remove redundant first two columns

for d=1:length(folders),
    cd([topDir '\' folders{d}]);
    files = struct2cell(dir); files = files(1,3:length(files));
    trialVarData{d}=dlmread(files{1}); %Import Picto Analysis Trial Variables file
    eventData{d}=dlmread(files{2}); %Import Picto Analysis .e file containing Picto event markers    
end

%Import SQL .csv database file containing alignevents table
disp('Select SQL alignevents file (.csv)')
[alignevent, aligneventPath] = uigetfile( '*.csv', 'Open file...' );
cd(aligneventPath)
M = csvread(alignevent,1,3);
Y1=M(:,1); %Neural Time Column
Y2=M(:,2); %Behavioral Time Column

% disp('Select first Picto Analysis Event file (.e.txt)')
% [eventFile, eventPath] = uigetfile( '*.txt', 'Open file...' );
% cd(eventPath)
% eventData = dlmread(eventFile); %#ok<*SAGROW>
% 
% %Import Picto Analysis Trial Variables file
% disp('Select first Picto Trial Variables file (.data.txt)')
% [trialVarFile, trialVarPath] = uigetfile( '*.txt', 'Open file...' );
% cd(trialVarPath)
% trialVarData = dlmread(trialVarFile); %#ok<*SAGROW>
%for 1:length(folders)
    
%% Interpolate values
nMarkers = 4; %number of event markers per trial (Wes' data = 4)
for a=1:length(eventData), %number of rows (trials)
    for b=1:nMarkers,
        if eventData(a,b)>0, %Skip missing trial data that has been labeled as "0"
            % Step 1 - Determines Picto Time unknown (interpolated values)
            eventBehTime = eventData(a,b); % Behavioral data time for event of interest
            belowX = find(Y2<eventBehTime, 1, 'last' ); % find closest X-value below targetValue
            aboveX = find(Y2>eventBehTime, 1 ); % find closest X-value above targetValue
            %belowX = max(find(Y2<eventBehTime)); % find closest X-value below targetValue
            %aboveX = min(find(Y2>eventBehTime)); % find closest X-value above targetValue
            belowY = Y2(belowX); aboveY = Y2(aboveX);
            eventBehX = 1 / ((aboveY-belowY) / (eventBehTime-belowY)) + belowX;   %Interpolation equation
            
            % Step 2- Determines Plexon Neural Time unknown (interpolated values)
            eventNeuralX(a,b) = (Y1(aboveX)-Y1(belowX)) * (eventBehX-belowX) + Y1(belowX); %Interpolation equation
        else
            eventNeuralX(a,b) = 0; %If data is "0", return "0"
        end
    end
end
plexonTime=round(eventNeuralX*1000); %Convert data to ms and round

%% Create epochs using plexonTime markers
% for c=1:length(plexonTime), %rows of data
%     if plexonTime(c(4))>0,
%         epoch{1}=LFP(plexonTime(c(1)) : plexonTime(c(4)) );
%     else
%         epoch{1}=LFP(plexonTime(c(1)) : plexonTime(c(3)) );
%     end
% end

%% Organize data by Trial Type



%% Time Frequency Spectrum Analysis


%% Coherency Analysis




%Linear Fit Equation: y=0.17*x - 4.9e+02; FLIPPED: x = y/0.17 + 4.9e+02

%for a=1:length(folders),
    %cd([topDir '\' folders{a}])
    %files = struct2cell(dir); files = files(1,3:length(files));
    %pictoData{a} = dlmread(files{1}); %#ok<*SAGROW>
%end

%% Import Plexon file (.pl2) *First must addPath of Plexon's MatlabOfflineFilesSDK directory
% addpath ('E:\fieldtrip-20151202')
% [filename, segmentPath] = uigetfile( '*.pl2', 'Open file...' );
% cd(segmentPath);
% cfg = [];
% cfg.dataset = filename;
% cfg.filetype = 'plexon_plx_v2';
% cfg.headerformat = 'plexon_plx_v2'
% cfg.dataformat = 'plexon_plx_v2';

%% Import .nex files using FT
% addpath ('E:\fieldtrip-20151202')
% [filename, segmentPath] = uigetfile( '*.nex', 'Open file...' );
% cd(segmentPath);
%ft_hastoolbox('PLEXON', 1);
% cfg = [];
% cfg.dataset = filename;
% cfg.continuous = 'yes';
% cfg.channel = 5;
% cfg.lpfilter = 'yes'; cfg.lpfreq = 300;
% [data] = ft_preprocessing(cfg)
%[data] = ft_preprocessing(cfg, data) %If data was previous loaded using ft_preprocessing
% cfg.trialdef   = []; %structure with details of trial definition
% cfg.trialfun   = []; %string with function name, see below (default = 'ft_trialfun_general')
% cfg.dataset    = []; %pathname to dataset from which to read the events
% 
% [cfg] = ft_definetrial(cfg);
%data_all = ft_preprocessing(cfg); %.plx files
%cd E:\fieldtrip-20151202 %change to fieldtrip directory
%hdr = ft_read_header(filename); %.nex files
%dat = ft_read_data(filename, 'chanindx', 5, 'begsample', 1, 'endsample', hdr.nSamples); %hdr.nSamples; channel 5 is WB? 6 is LFP
%plot(dat)
%cfg.hpfilter = 'yes'; %cfg.hpfreq = 300;
%plot(data.trial{1});

%% Filter attempts
%fdatool;
%Fpass=[0 300]; 
%[b,a]=butter(n,2*Fpass(1,2)*2/Fs,'low'); %Low pass filter
%lfp(2,:)=filtfilt(b,a,lfp(1,:));
%Use script below for multiple passes such as [0 10; 10 25; 25 45];
%for ii=2:3
%    [b,a]=butter(n,Fpass(ii,:)*2/Fs); %Band pass filter
%    lfp(:,ii+1)=filtfilt(b,a,lfp(:,1)); %Run forwards and backwards
%end
%Fc=300; %Cutoff Frequency (Hz)
%order = 5; % Filter order
%LPF = dsp.LowpassFilter(SampleRate,1000,FilterType,'FIR');
%% UI Prompt for Picto file input to obtain trial boundaries and event markers

%% defineTrial function
%From dbBrowserLite "runs" tab
%Session_2015_08_27__14_51_12.sqlite (4 sessions)
%08_28__02_58_02 Frames 192324:1348590
%08_28__03_25_33 Frames 1360088:3083025
%08_28__03_47_50 Frames 3094523:5292276
%08_28__04_15_57 Frames 5303774:9254696

%hdr = ft_read_header('eeg1_2.dat');