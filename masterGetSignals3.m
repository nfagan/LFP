function concatenatedSignals = masterGetSignals3(dataType,trialInfo,windowInfo)

%%% Parse Global Inputs    

outcome = trialInfo.outcome;
trialType = trialInfo.trialType;
epoch = trialInfo.epoch;

stepSize = windowInfo.stepSize;
windowSize = windowInfo.windowSize;
lengthToPlot = windowInfo.lengthToPlot + windowSize;
initial = windowInfo.initial;

filterSignal = 1;
filterCutoff = 250; %hz

loadIn = 1; %always load

if strcmp(computer,'MACI64');
    if (strcmp(dataType,'Olga BLA')) || ((strcmp(dataType,'Olga ACC')))
%         umbrellaDirectory = '/Volumes/My Passport/NICK/Chang Lab 2016/LFP/Olgas_Data_Targac/';
        umbrellaDirectory = '/Volumes/My Passport/NICK/Chang Lab 2016/LFP/cheek_electrode_data/Olga to Nick/';
    elseif strcmp(dataType,'testCheek')
%         umbrellaDirectory = '/Volumes/My Passport/NICK/Chang Lab 2016/LFP/test_spikes/';
        umbrellaDirectory = '/Volumes/My Passport/NICK/Chang Lab 2016/LFP/cheek_electrode_data/Olga to Nick/';
    end
else
    umbrellaDirectory = '/Volumes/My Passport/NICK/Chang Lab 2016/LFP/Olgas_Data_Targac/';
end

folderDirectory = getFolderDirectory(umbrellaDirectory);

allSignals = cell(length(folderDirectory),1); %preallocate allSignals

%%% Begin obtaining signals

for k = 1:length(folderDirectory); % for looping through DATA FILES

%%% Display inputs and number of files to be processed

    infoStr = sprintf('\n Area: %s\n Trial type(s): %s\n Outcome(s): %s\n Epoch: %s', ...
dataType(end-2:end),trialType,outcome,lower(epoch));
    str = sprintf('\n \n Processing File %d of %d',k,length(folderDirectory));
    fprintf(infoStr);
    fprintf(str);
    
%%% Load + Format Data

    startDirectory = strcat(umbrellaDirectory,folderDirectory(k).name,'/');
    cd(startDirectory);

if loadIn;   
    fprintf('\n \n \t Loading in Data...');
    [plex,eventData,trialVarData,M] = getDataFiles2(startDirectory,dataType,1);  
else
    return;
end
fprintf('\n \t \t Done');

[eventData,trialVarData,M] = cleanUpData(eventData,trialVarData,M);

%%% different for check

% strobeTimes = plex.reformatted(:,2);
% firstAlignCode = plex.reformatted(1,1);
% 
% M(:,1) = 0; M(firstAlignCode:firstAlignCode+length(strobeTimes)-1,1) = strobeTimes;

%%% Fix Reference Times

% M(:,1) = plex.reformatted(:,2);

%%% new for testCheek

ind = plex.reformatted(:,1);
M = M(ind,:);
M(:,1) = plex.reformatted(:,2);

%%% Filter Signal
if filterSignal
    fprintf('\n \n \t Filtering Signal...');
%     LFP = doFilter2(plex,filterCutoff); %raw signal, filter cutoff
    LFP = zeroPhaseFilter(plex,filterCutoff,10); %raw signal, filter cutoff
    plex.ad = LFP;
    fprintf('\n \t \t Done');
end

%%% Interpolate values + Create epochs using plexonTime markers

[allTimes,errorIndex] = getEventTimes4(eventData,M);
% [allTimes,errorIndex] = getEventTimesReg(eventData,M);

%%% Remove Errors

[allTimes,trialVarData] = removeErrorTrials(allTimes,trialVarData,errorIndex); %remove errors first

%%% Separate Trials by Reward Outcome, and optionally by Trial Type

trialVarData = trialVarData(:,2:end); %%% for cheeck check ** change later

allTimes = epochSort3(trialVarData,allTimes,outcome,trialType);

%%% Get Signal For the Wanted Epoch
fprintf('\n \n \t Getting Signals...');

% allSignals{k} = simulated_getWantedSignal(plex,allTimes,epoch,lengthToPlot,initial);
[allSignals{k},saveIndex] = getWantedSignalTargAc(plex,allTimes,epoch,lengthToPlot,windowSize,initial);

fprintf('\n \t \t Done');
end%loop through data files

%%% Concatenate Across Files
fprintf('\n \n Concatenating Signals...');
concatenatedSignals = concatenateAcrossFiles(allSignals);
fprintf('\n \t Done');

% %%% Do stepped window
% fprintf('\n \n Generating Window Steps...');
% concatenatedSignals = getWindows(concatenatedSignals,stepSize,windowSize);
% fprintf('\n \t Done');
