function [plex,eventData,trialVarData,M] = getDataFiles2(directory,channel,doPlex,LFP)

switch channel
    case 'Olga BLA'
        channelName = 'WB10';
    case 'Olga ACC' 
        channelName = 'WB09';
    case 'Wes BLA'
        channelName = 'WB01';
    case 'test'
%         channelName = 'WB01';
        channelName = 'SPK09';
end

% get Plexon file
plexFile = getFileType(directory,'pl2');

if doPlex
    
% plex = getPlexonDataTest(plexFile,channelName);   
plex = getPlexonData(plexFile,channelName);

else
    
    if nargin>3;    
        plex.ad = LFP;        
    end        
%     plex = NaN;

end

append = 'behavioral data';        
outerPath = (strcat(directory,append));        
cd(outerPath);

d = dir(outerPath); %all files in directory        
names = {d(:).name}; %all names of files in directory
isNotFolder = (strcmp(names,'.') == 1) | (strcmp(names,'..')) | (strcmp(names,'.DS_Store')); %get rid of names that aren't folders        
d(isNotFolder) = []; %actual deletion 

%remove 'rem' folders from directory
d = remDir(d);

%put blocks into struct

for folderNumber = 1:length(d);

folderName = d(folderNumber).name;
fullPath = fullfile(outerPath,folderName);
% fullPath = strcat(outerPath,'/',folderName); %get file path 
cd(fullPath);        

%get Picto Event File
fileToLoad = strcat(folderName,'.e.txt');        
eventDataOneBlock = dlmread(fileToLoad); %eventData is output 

%Import Picto Analysis Trial Variables file
fileToLoad = strcat(folderName,'.data.txt');
trialVarDataOneBlock = dlmread(fileToLoad); %trialVarData is output

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
        M = csvread(csvDir(i).name,1); %column 1 = Plexon Time; column 2 = Picto time
    else
        update = csvread(csvDir(i).name,1);
        M = vertcat(M,update);
    end;
end;


