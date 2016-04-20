% getFolderDirectory.m - function for eliminating non-folder items from the
% directory, as well as (in the case of OSX), sub- and super-folder (. &
% ..) references. Additionally, folders prefixed with 'rem' will be removed
% from the output-directory.

function folderDirectory = getFolderDirectory(umbrellaDirectory)

d = dir(umbrellaDirectory);
nameCheck = {d(:).name};

sizeCheck = zeros(1,length(nameCheck));
for i = 1:length(nameCheck); %for each item of the directory ...
    
    oneCheck = char(nameCheck{i});
    
    if length(oneCheck) < 3; %if the directory name is less than 3 characters,
                             %mark it for removal
        sizeCheck(i) = 1;
    else
        sizeCheck(i) = 0;
    end;
end

sizeCheck = logical(sizeCheck');
d(sizeCheck) = []; %remove (.) & (..) & rem folders

d = remDir(d); %remove folders prefixed with 'rem'

dirCheck = logical(cell2mat({d(:).isdir}')); %remove other non-folder items
d(~dirCheck) = [];

folderDirectory = d;
