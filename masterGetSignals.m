function concatenatedSignals = masterGetSignals(dataType,trialInfo,windowInfo,allLFPNoiseRemoved)

%%% Parse Global Inputs    

outcome = trialInfo.outcome;
trialType = trialInfo.trialType;
epoch = trialInfo.epoch;

windowSize = windowInfo.windowSize;
stepSize = windowInfo.stepSize;
lengthToPlot = windowInfo.lengthToPlot;
initial = windowInfo.initial;

filterCutoff = 250;

if nargin>3
    loadIn = 0; 
else
    loadIn = 1;
end

if (strcmp(dataType,'Olga BLA')) || ((strcmp(dataType,'Olga ACC')));
    umbrellaDirectory = '/Volumes/My Passport/NICK/Chang Lab 2016/LFP/Olgas_Data_reformatted/recording data analysis _ olga/';
else
    umbrellaDirectory = '/Volumes/My Passport/NICK/Chang Lab 2016/LFP/Wes_data_reformatted/Plex_and_Picto/';
end

%%% Calculations Based on Inputs

folderDirectory = getFolderDirectory(umbrellaDirectory);

if ~isfield(windowInfo,'nWindows');
    numWindows = lengthToPlot/stepSize;
else
    numWindows = windowInfo.nWindows;
end
    

for k = 1:length(folderDirectory); % for looping through DATA FILES
    
    startDirectory = strcat(umbrellaDirectory,folderDirectory(k).name,'/');
    cd(startDirectory);
    
%%% Load + Format Data

if loadIn;   
    [plex,eventData,trialVarData,M] = getDataFiles(startDirectory,dataType,1);  
else
    if nargin>3
        [plex,eventData,trialVarData,M] = getDataFiles(startDirectory,dataType,0,allLFPNoiseRemoved{k});
    else
        return
    end
end

[eventData,trialVarData,M] = cleanUpData(eventData,trialVarData,M);

%%% Fix Reference Times

M(:,2) = plex.

%%% Filter Signal

LFP = doFilter(plex,filterCutoff); %raw signal, filter cutoff

%%% Interpolate values + Create epochs using plexonTime markers

% [allTimes,errorIndex] = getEventTimes3(eventData,M);
[allTimes,errorIndex] = getEventTimes4(eventData,M);

%%% Remove Errors

[allTimes,trialVarData] = removeErrorTrials(allTimes,trialVarData,errorIndex); %remove errors first

%%% Separate Trials by Reward Outcome, and optionally by Trial Type

allTimes = epochSort3(trialVarData,allTimes,outcome,trialType);

%%% Get Signal For the Wanted Epoch

for i = 1:numWindows;
    
    if i > 1;
        initial = initial+stepSize;
    end;

allSignals{k,i} = getWantedSignal2(LFP,allTimes,epoch,windowSize,initial);

end;

end

%%% Concatenate Across Files

concatenatedSignals = concatenateAcrossFiles(allSignals);