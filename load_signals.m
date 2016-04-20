function concatenatedSignals = load_signals(umbrellaDirectory,dataType,trialInfo,windowInfo)

fprintf('---------------------------'); % Just to make it obvious when the 
                                        % function was re-run

global storePlex; % For storing the plexon signals, such that they won't have
                  % to be reloaded as frequently (eats up RAM, however!)
global storeDataType; % For checking whether there were changes to the dataType,
                      % i.e., whether neural data will have to be reloaded
global forceReload; % If wanting to manually reload the data

if isempty(forceReload);
    forceReload = 0; % By default, don't force-reload
end

%%% - Parse Global Inputs    

outcome = trialInfo.outcome;
trialType = trialInfo.trialType; % choice, cued, or all
epoch = trialInfo.epoch;

stepSize = windowInfo.stepSize;
windowSize = windowInfo.windowSize;
lengthToPlot = windowInfo.lengthToPlot + windowSize; % Do this in order to 
                                                     % have data for the
                                                     % last time-window
initial = windowInfo.initial;

filterSignal = 1; % Do filter the signal
filterCutoff = 250; % Hz

%%% - Check validity of inputs and structure of umbrellaDirectory

if strcmp(epoch,'Target Acquire') && strcmp(trialType,'cued')
    % If user specifies target acquire (choice) epoch and cued trials,
    % report an error
    error('Alignment times for target acquire don''t exist for cued trials.');
end

loadIn = 0; % By default, assume that plexon data is already loaded; 
            % this will be switched to 1 if storePlex is an empty double,
            % if storePlex encompasses fewer .pl2 files than exist in
            % the umbrellaDirectory, or if forceReload is set to 1

valid = check_folder_structure(umbrellaDirectory,0); % Confirm that umbrella
                                                     % Directory is
                                                     % formatted correctly
if ~valid
    error(['The specified umbrella directory is not formatted correctly.' ...
        , ' Resolve the conflicts printed above, or else input' ...
        , ' ''check_folder_structure(umbrellaDirectory)'' to view them again.']);
end
    
folderDirectory = getFolderDirectory(umbrellaDirectory); % Get rid of 'rem', 
                                                         % '.', and '..'
                                                         % folders in
                                                         % umbrellaDirectory

allSignals = cell(length(folderDirectory),1); % Preallocate allSignals

if isa(storePlex,'double') || ~strcmp(dataType,storeDataType) || forceReload;
    loadIn = 1; % Load plexon data if it doesn't already exist, as long
                % as the dataType hasn't changed and forceReload is false
    storePlex = cell(length(folderDirectory),1); % Preallocate plexon data store
elseif length(storePlex) ~= length(folderDirectory) || isempty(storePlex{1}) ...
        || ~strcmp(dataType,storeDataType)
    loadIn = 1; % Load plexon data if there were more subfolders added to 
                % the umbrellaDirectory since the last time the function
                % was run
    storePlex = cell(length(folderDirectory),1);
else % Don't load plexon data, but alert user that this will be the case
    fprintf('\n\n');
    warning(['The outputted signals will be derived from plexon data that' ...
        , ' already exists in the workspace. If you have added .pl2 files to the' ...
        , ' working directory, or changed the properties of the filter, set forceReload' ...
        , ' = 1 and rerun the script to incorporate those changes.']);
end

%%% - Begin obtaining signals

for k = 1:length(folderDirectory); % For looping through DATA FILES

%%% - Display inputs and number of files to be processed

    infoStr = sprintf('\n\n Area: %s\n Trial type(s): %s\n Outcome(s): %s\n Epoch: %s', ...
dataType(end-2:end),trialType,outcome,lower(epoch));
    str = sprintf('\n \n Processing File %d of %d',k,length(folderDirectory));
    fprintf(infoStr);
    fprintf(str);
    
%%% - Load + Format Data

    startDirectory = fullfile(umbrellaDirectory,folderDirectory(k).name);
    cd(startDirectory);
if loadIn; % If storePlex is empty ...
    fprintf('\n \n \t Loading in Data...');
    [plex,eventData,trialVarData,M] = getDataFiles2(startDirectory,dataType,1);
    fprintf('\n \t \t Done');
else % Otherwise, just load the trial data, and use neural data from storePlex
    fprintf('\n \n \t Using Neural Data from Workspace Variable storePlex...');
    [~,eventData,trialVarData,M] = getDataFiles2(startDirectory,dataType,0);
    plex = storePlex{k};
end

[eventData,trialVarData,M] = cleanUpData(eventData,trialVarData,M); % Make 
                                                            % our cell arrays
                                                            % into matrices

%%% - Fix Reference Times

if size(M,1) == size(plex.reformatted,1); % Change neural-reference times to 
                                          % those stored in the .pl2 file
    M(:,1) = plex.reformatted(:,2);
else % If the .pl2 file encompasses the full recording session, the strobed-
     % times between Picto and Plexon (from the .pl2 file) will match in
     % length. Otherwise, we'll have to pull out the Picto-strobed times
     % that match the subset of plexon strobed times that we obtain from the
     % .pl2 file.
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

%%% - Filter Signal

if filterSignal && loadIn
    fprintf('\n \n \t Filtering Signal...');
    LFP = zeroPhaseFilter(plex,filterCutoff,10); % (rawSignal, HF cutoff,
                                                 % LF cutoff)
    plex.ad = LFP;
    fprintf('\n \t \t Done');
else
    fprintf('\n \n \t Not Filtering the Signal Because storePlex Has Data In It...');
end

%%% - Interpolate time values + Create epochs using plexonTime markers

[allTimes,errorIndex] = getEventTimes4(eventData,M);
% [allTimes,errorIndex] = getEventTimesReg(eventData,M);

%%% - Remove Errors

[allTimes,trialVarData] = removeErrorTrials(allTimes,trialVarData,errorIndex);

%%% - Separate Trials by Reward Outcome, and optionally by Trial Type

if trialVarData(:,1) == trialVarData(:,2) & size(trialVarData,2) == 18;
                                            % Sometimes, picto appears to 
                                            % add a duplicate column for 
                                            % trial number; we'll remove 
                                            % that duplicate here.

    warning(['The picto data file (''...''.data.txt) has duplicate columns 1 and 2.' ...
        , ' These columns correspond to trial number; the first column will be removed.']);
    trialVarData = trialVarData(:,2:end);
elseif size(trialVarData,2) ~= 17;
    error(['The Picto trial info data file (''...''.data.txt) must have 17 columns;'...
        , ' the current data file has %d.'],size(trialVarData,2));
end

allTimes = epochSort4(trialVarData,allTimes,outcome,trialType);

%%% - Get Signal For the Wanted Epoch

fprintf('\n \n \t Getting Signals...');
[allSignals{k},~] = getWantedSignalTargAc(plex,allTimes,epoch,lengthToPlot,windowSize,initial);
storePlex{k} = plex; % Store neural data
fprintf('\n \t \t Done');
end % End loop through data files

%%% - Concatenate Across Files
fprintf('\n \n Concatenating Signals...');
concatenatedSignals = concatenateAcrossFiles(allSignals);
fprintf('\n \t Done\n\n');

storeDataType = dataType; % Store the previous run's dataType, to check 
                          % whether neural data will have to be reloaded

% %%% Do stepped window
% fprintf('\n \n Generating Window Steps...');
% concatenatedSignals = getWindows(concatenatedSignals,stepSize,windowSize);
% fprintf('\n \t Done');
