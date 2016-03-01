function [plex,eventData,trialVarData,M] = getDataFiles(directory,channel,doPlex,LFP)

switch channel
    case 'Olga BLA'
        channelName = 'WB10';
    case 'Olga ACC' 
        channelName = 'WB09';
    case 'Wes BLA'
        channelName = 'WB01';
end

% get Plexon file
plexFile = getFileType(directory,'pl2');

if doPlex

[adfreq, n, ts, fn, ad] = plx_ad_v(plexFile.name, channelName); %Plexon SDK

%plexon outputs
plex.adfreq = adfreq;
plex.n = n;
plex.ts = ts;
plex.fn = fn;
plex.ad = ad;

times(1) = plex.ts;

    for j = 2:length(plex.ad);
        times(j) = times(j-1)+.001;
    end
    
    plex.times = times';

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

%put blocks into struct

for folderNumber = 1:length(d);

folderName = d(folderNumber).name;
fullPath = strcat(outerPath,'/',folderName); %get file path 
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

%Import SQL .csv database file containing alignevents tabl
cd(directory);     

csvDir = getFileType(cd,'csv');

for i = 1:length(csvDir);            
    if i < 2;
        M = csvread(csvDir(i).name,1); %column 1 = Plexon Time; column 2 = Picto time
    else
        update = csvread(csvDir(i).name,1);
        M = vertcat(M,update);
    end;
end;
