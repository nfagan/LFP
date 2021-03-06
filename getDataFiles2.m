function [plex,eventData,trialVarData,M] = getDataFiles2(directory,channel,doPlex,LFP)

switch channel
    case 'BLA:SPIKE'
        channelName = ''; % fill in later
    case 'ACC:SPIKE'
        channelName = '';
    case 'BLA:LFP'
        channelName = 'WB09';
    case 'ACC:LFP'
        channelName = 'WB10';
    case 'mouth'
        channelName = 'WB11';
    case 'Olga BLA' % kept in for compatability reasons
        channelName = 'WB10';
    case 'Olga ACC' % kept in for compatability reasons
        channelName = 'WB09';
    case 'Wes BLA'% kept in for compatability reasons
        channelName = 'WB01';
    case 'testCheek'
%         channelName = 'WB01';
%         channelName = 'SPK09';
        channelName = 'WB11';
end

% get Plexon file
plexFile = getFileType(directory,'pl2');

if doPlex
% plex = getPlexonDataTest(plexFile,channelName);   
plex = getPlexonData(plexFile,channelName);
else
    if nargin>3;    
        plex.ad = LFP;
    else
        plex = NaN;
    end
end

append = 'behavioral data';        
outerPath = fullfile(directory,append);
cd(outerPath);

d = only_folders(rid_super_sub_folder_references(dir(outerPath))); % get folders in directory
% names = {d(:).name}; %all names of files in directory
% isNotFolder = (strcmp(names,'.') == 1) | (strcmp(names,'..')) | (strcmp(names,'.DS_Store')); %get rid of names that aren't folders        
% d(isNotFolder) = []; %actual deletion 

%remove 'rem' folders from directory
d = remDir(d);

%put blocks into struct

for folderNumber = 1:length(d);

folderName = d(folderNumber).name;
fullPath = fullfile(outerPath,folderName);
cd(fullPath);        

%get Picto Event File

txtFileDir = dir('*.txt');
% eventExtension = fliplr('.e.txt');
% 
% txtFileNames = cellfun(@fliplr,{txtFileDir(:).name},'UniformOutput',false);
% 
% eventFileDir = txtFileDir(strncmpi(txtFileNames,eventExtension,length(eventExtension)));

eventFileDir = dir('*.e.txt');

if length(eventFileDir) > 1;
    error('More than one possible event file');
end

eventDataOneBlock = dlmread(eventFileDir(1).name);

% fileToLoad = strcat(folderName,'.e.txt');        
% eventDataOneBlock = dlmread(fileToLoad); %eventData is output 

%Import Picto Analysis Trial Variables file
% trialExtension = fliplr('.data.txt');
% trialFileDir = txtFileDir(strncmpi(txtFileNames,trialExtension,length(trialExtension)));

trialFileDir = dir('*.data.txt');

if length(trialFileDir) > 1;
    error('More than one possible trial-data file');
end

trialVarDataOneBlock = dlmread(trialFileDir(1).name);

% fileToLoad = strcat(folderName,'.data.txt');
% trialVarDataOneBlock = dlmread(fileToLoad); %trialVarData is output

eventData{folderNumber} = eventDataOneBlock;
trialVarData{folderNumber} = trialVarDataOneBlock;

end

%Import SQL .csv database file containing alignevents table
cd(directory);     

csvDir = getFileType(cd,'csv');

%remove 'rem' files from directory;
csvDir = remDir(csvDir);

for i = 1:length(csvDir);            
    if i < 2;
        try 
            M = csvread(csvDir(i).name); %attempt to load all rows of .csv file
        catch %if string column headers exist, load all values EXCEPT the column headers
            M = csvread(csvDir(i).name,1); %column 1 = Plexon Time; column 2 = Picto time 
        end
    else
        try
            update = csvread(csvDir(i).name);
        catch
            update = csvread(csvDir(i).name,1);
        end
        M = vertcat(M,update);
    end;
end;


