function concatenatedSignals = masterGetSignals2(dataType,trialInfo,windowInfo,allLFPNoiseRemoved)

%%% Parse Global Inputs    

outcome = trialInfo.outcome;
trialType = trialInfo.trialType;
epoch = trialInfo.epoch;

windowSize = windowInfo.windowSize;
stepSize = windowInfo.stepSize;
lengthToPlot = windowInfo.lengthToPlot;
initial = windowInfo.initial;

filterCutoff = 250; %hz

if nargin>3
    loadIn = 0; 
else
    loadIn = 1;
end

if (strcmp(dataType,'Olga BLA')) || ((strcmp(dataType,'Olga ACC')));
%     umbrellaDirectory = '/Volumes/My Passport/NICK/Chang Lab 2016/LFP/Olgas_Data_reformatted/recording data analysis _ olga/';
    umbrellaDirectory = '/Volumes/My Passport/NICK/Chang Lab 2016/LFP/Olgas_Data_Targac/';
else
    umbrellaDirectory = '/Volumes/My Passport/NICK/Chang Lab 2016/LFP/Wes_data_reformatted/Plex_and_Picto/';
end

%%% Calculations Based on Inputs

folderDirectory = getFolderDirectory(umbrellaDirectory);
folderDirectory(2) = []; %CHANGE LATER

if ~isfield(windowInfo,'nWindows');
    numWindows = lengthToPlot/stepSize;
else
    numWindows = windowInfo.nWindows;
end

for k = 1:length(folderDirectory); % for looping through DATA FILES
    disp(strcat(num2str(k),'/',num2str(length(folderDirectory))));
    
    startDirectory = strcat(umbrellaDirectory,folderDirectory(k).name,'/');
    cd(startDirectory);
    
%%% Load + Format Data

if loadIn;   
    disp('Loading in Data...');
    [plex,eventData,trialVarData,M] = getDataFiles2(startDirectory,dataType,1);  
else
    if nargin>3
        [plex,eventData,trialVarData,M] = getDataFiles2(startDirectory,dataType,0,allLFPNoiseRemoved{k});
    else
        return
    end
end

[eventData,trialVarData,M] = cleanUpData(eventData,trialVarData,M);

%%% Fix Reference Times

M(:,1) = plex.reformatted(:,2);

%%% Filter Signal
disp('Filtering Signal...');
LFP = doFilter2(plex,filterCutoff); %raw signal, filter cutoff
plex.ad = LFP;

%%% Interpolate values + Create epochs using plexonTime markers

[allTimes,errorIndex] = getEventTimes4(eventData,M);

%%% Remove Errors

[allTimes,trialVarData] = removeErrorTrials(allTimes,trialVarData,errorIndex); %remove errors first

%%% Separate Trials by Reward Outcome, and optionally by Trial Type

allTimes = epochSort3(trialVarData,allTimes,outcome,trialType);

%%% Get Signal For the Wanted Epoch
disp('Getting Signals...');
for i = 1:numWindows;    
    toDisplay = strcat(num2str(i),'/',num2str(numWindows));
    tic
    disp(toDisplay);
    if i > 1;
        initial = initial+stepSize;
    end;

allSignals{k,i} = getWantedSignalTargAc(plex,allTimes,epoch,windowSize,initial);
toc
end;

end%loop through data files

%%% Concatenate Across Files
disp('Concatenating Signals...');
concatenatedSignals = concatenateAcrossFiles(allSignals);

disp('Done');