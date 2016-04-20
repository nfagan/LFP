% check_folder_structure.m - function for checking the validity of the
% formatting of the data folder (and its subfolders) for use with
% load_signals.m.
%
% Explicitly declare checkRemFolders = 0 if NOT wanting to scan folders
% prefixed with rem; these folders will, regardless of the inputs to this 
% function, be skipped by load_signals.m.

function valid = check_folder_structure(umbrellaDirectory,checkRemFolders)

if nargin < 2; %by default, do analyze folders prefixed with rem
    checkRemFolders = 1;
end
cd(umbrellaDirectory);

d = dir(cd);
d(~logical(cell2mat({d(:).isdir}'))) = []; %remove non-folder directories

toRemove = zeros(1,length(d)); %remove '.' and '..' directories
for i = 1:length(d);
    if strcmp(d(i).name,'.') || strcmp(d(i).name,'..');
        toRemove(i) = 1;
    end
end
d(logical(toRemove)) = [];

if ~checkRemFolders %if wanting to check only directories that are not prefixed rem,
                    %i.e., only directories that load_signals will
                    %attempt to pull from ...
    d = remDir(d,'n'); %'n' suppresses warnings from remDir
end

stp = 1; storeMessage = [];
for i = 1:length(d);
    cd(fullfile(umbrellaDirectory,d(i).name)); %cd -> subfolder(i)
                                               %check number of csv and 
                                               %.pl2 files, ignoring 
                                               %entries prefixed with rem
    checkPlex = length(remDir(dir('*.pl2'),'n')); 
    checkCSV = length(remDir(dir('*.csv'),'n'));
    
    subDir = dir;
    behavioralDataExists = zeros(1,length(subDir)); %check for presence of 
                                                    %behavioral data subfolder
    for k = 1:length(subDir);
        if strcmp(subDir(k).name,'behavioral data');
            behavioralDataExists(k) = 1;
        end
    end
    
    if checkPlex > 1; %if there's more than one non-rem prefixed .pl2 file ...
        storeMessage{stp} = sprintf(['The subfolder (%s) has more than one' ...
            , ' .pl2 file'],d(i).name);
        stp = stp+1;
    elseif checkPlex == 0; %if no .pl2 file exists ...
        storeMessage{stp} = sprintf(['The subfolder (%s) is missing a' ...
            , ' .pl2 file'],d(i).name);
        stp = stp+1;
    end
    
    if checkCSV > 1; %if there's more than one non-rem prefixed .csv file ...
        storeMessage{stp} = sprintf(['The subfolder (%s) has more than one' ...
            , ' .csv file'],d(i).name);
        stp = stp+1;
    elseif checkCSV == 0; %if no .csv file exists ...
        storeMessage{stp} = sprintf(['The subfolder (%s) is missing a'...
            , ' .csv file'],d(i).name);
        stp = stp+1;
    end
    
    if sum(behavioralDataExists) == 0; %if no 'behavioral data' subsubfolder exists ...
        storeMessage{stp} = sprintf(['The subfolder (%s) is missing a' ...
            , ' ''behavioral data'' sub-subfolder,\n or else the' ...
            , ' behavioral data sub-subfolder is named incorrectly.'],d(i).name);
        stp = stp+1;
    end
    
end

if isempty(storeMessage);
    fprintf('\nThe umbrella directory appears to be formatted correctly.');
    valid = 1;
else
    for i = 1:length(storeMessage);
        fprintf('\n%s',storeMessage{i});
    end
    valid = 0;
end


        

