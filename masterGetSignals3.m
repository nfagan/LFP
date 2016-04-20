function concatenatedSignals = masterGetSignals3(umbrellaDirectory,dataType,trialInfo,windowInfo)

global storePlex;

%%% - Parse Global Inputs    

outcome = trialInfo.outcome;
trialType = trialInfo.trialType; %choice, cued, or all
epoch = trialInfo.epoch;

stepSize = windowInfo.stepSize;
windowSize = windowInfo.windowSize;
lengthToPlot = windowInfo.lengthToPlot + windowSize; %do this in order to 
                                                     %have data for the
                                                     %last time-window
initial = windowInfo.initial;

filterSignal = 1; %do filter
filterCutoff = 250; %hz

%%% - Check validity of inputs and structure of umbrellaDirectory

if strcmp(epoch,'Target Acquire') && strcmp(trialType,'cued')
    %if user specifies target acquire (choice) epoch and cued trials,
    %report an error
    error('Alignment times for target acquire don''t exist for cued trials.');
end

loadIn = 0; % by default, assume that plexon data is already loaded; 
            % this will be switched to 1 if storePlex is an empty double,
            % or if storePlex encompasses fewer .pl2 files than exist in
            % the umbrellaDirectory

valid = check_folder_structure(umbrellaDirectory,0); %confirm that umbrella
                                                     %Directory is
                                                     %formatted correctly
if ~valid
    error(['The specified umbrella directory is not formatted correctly.' ...
        , ' Resolve the conflicts printed above, or else input' ...
        , ' ''check_folder_structure(umbrellaDirectory)'' to view them again.']);
end
    
folderDirectory = getFolderDirectory(umbrellaDirectory); %get rid of rem, 
                                                         %'.', and '..'
                                                         %folders in
                                                         %directory

allSignals = cell(length(folderDirectory),1); %preallocate allSignals

if isa(storePlex,'double');
    loadIn = 1; %load plexon data if it doesn't already exist
    storePlex = cell(length(folderDirectory),1); %preallocate plexon data store
elseif length(storePlex) ~= length(folderDirectory) || isempty(storePlex{1});
    loadIn = 1; %load plexon data if there were more subfolders added to the umbrellaDirectory
    storePlex = cell(length(folderDirectory),1); %preallocate plexon data store
else %don't load plexon data, but alert user that this will be the case
    warning(['The outputted signals will be derived from plexon data that' ...
        , ' already exists in the workspace. If you have added .pl2 files to the' ...
        , ' working directory, or changed the properties of the filter, set storePlex' ...
        , ' = []; and rerun the script to incorporate those changes.']);
end

%%% Begin obtaining signals

for k = 1:length(folderDirectory); % for looping through DATA FILES

%%% Display inputs and number of files to be processed

    infoStr = sprintf('\n\n Area: %s\n Trial type(s): %s\n Outcome(s): %s\n Epoch: %s', ...
dataType(end-2:end),trialType,outcome,lower(epoch));
    str = sprintf('\n \n Processing File %d of %d',k,length(folderDirectory));
    fprintf(infoStr);
    fprintf(str);
    
%%% Load + Format Data

    startDirectory = fullfile(umbrellaDirectory,folderDirectory(k).name);
    cd(startDirectory);
if loadIn; %if storePlex is empty ...
    fprintf('\n \n \t Loading in Data...');
    [plex,eventData,trialVarData,M] = getDataFiles2(startDirectory,dataType,1);
    fprintf('\n \t \t Done');
else %otherwise, just load the trial data, and use neural data from storePlex
    fprintf('\n \n \t Using Data from Workspace Variable storePlex...');
    [~,eventData,trialVarData,M] = getDataFiles2(startDirectory,dataType,0);
    plex = storePlex{k};
end

[eventData,trialVarData,M] = cleanUpData(eventData,trialVarData,M);

%%% different for check

% strobeTimes = plex.reformatted(:,2);
% firstAlignCode = plex.reformatted(1,1);
% 
% M(:,1) = 0; M(firstAlignCode:firstAlignCode+length(strobeTimes)-1,1) = strobeTimes;

%%% Fix Reference Times

if size(M,1) == size(plex.reformatted,1); %change neural-reference times to those stored in the .pl2 file
    M(:,1) = plex.reformatted(:,2);
else %if the .pl2 file encompasses the full recording session, the strobed-
     %times between Picto and Plexon (from the .pl2 file) will match in
     %length. Otherwise, we'll have to pull out the Picto-strobed times
     %that match the subset of plexon strobed times that we obtain from the
     %.pl2 file.
    if size(plex.reformatted,1) < size(M,1);
        ind = plex.reformatted(:,1);
        M = M(ind,:);
        M(:,1) = plex.reformatted(:,2);
    else
        error(['The picto session file (.csv file) has fewer strobed-times than' ...
            , ' the plexon data file (.pl2 file). Confirm that 1) the entire columns'''...
            , ' worth of neuralTimes and behavioralTimes were copied into the .csv file'...
            , ' and 2) the .csv file corresponds to the correct .pl2 file.']);
    end
end

%%% new for testCheek

% ind = plex.reformatted(:,1);
% M = M(ind,:);
% M(:,1) = plex.reformatted(:,2);

%%% Filter Signal
if filterSignal && loadIn
    fprintf('\n \n \t Filtering Signal...');
%     LFP = doFilter2(plex,filterCutoff); %raw signal, filter cutoff
    LFP = zeroPhaseFilter(plex,filterCutoff,10); %raw signal, filter cutoff
    plex.ad = LFP;
    fprintf('\n \t \t Done');
else
    fprintf('\n \n \t Not Filtering the Signal Because storePlex Has Data In It...');
end

%%% Interpolate values + Create epochs using plexonTime markers

[allTimes,errorIndex] = getEventTimes4(eventData,M);
% [allTimes,errorIndex] = getEventTimesReg(eventData,M);

%%% Remove Errors

[allTimes,trialVarData] = removeErrorTrials(allTimes,trialVarData,errorIndex); %remove errors first

%%% Separate Trials by Reward Outcome, and optionally by Trial Type

%sometimes, picto appears to add a duplicate column for trial number; we'll
%remove the duplicate column here
if trialVarData(:,1) == trialVarData(:,2) & size(trialVarData,2) == 18;
    warning(['The picto data file (''...''.data.txt) has duplicate columns 1 and 2.' ...
        , ' These columns correspond to trial number; the first column will be removed.']);
    trialVarData = trialVarData(:,2:end);
elseif size(trialVarData,2) ~= 17;
    error(['The Picto trial info data file (''...''.data.txt) must have 17 columns;'...
        , ' the current data file has %d.'],size(trialVarData,2));
end

allTimes = epochSort4(trialVarData,allTimes,outcome,trialType);

%%% Get Signal For the Wanted Epoch
fprintf('\n \n \t Getting Signals...');

% allSignals{k} = simulated_getWantedSignal(plex,allTimes,epoch,lengthToPlot,initial);
[allSignals{k},~] = getWantedSignalTargAc(plex,allTimes,epoch,lengthToPlot,windowSize,initial);
storePlex{k} = plex; %store plex for raw-signal processing
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
