function direc = getFileType(directory,extension)

extension = fliplr(extension);

direc = dir(directory);
fileNames= {direc(:).name};
for i = 1:length(fileNames);
    fileNameToCompare = fileNames{i};
    fileNameToCompare = fliplr(fileNameToCompare);

    if length(fileNameToCompare) > 2 %if filename is longer than two characters ...                
        firstThree = fileNameToCompare(1:length(extension));
        if strcmp(firstThree,extension) ~= 1 %if the file is not a csv file remove it from the directory
            removeFromDir(i) = 1;
        else
            removeFromDir(i) = 0;
        end                    
    else % or else remove it from the directory
        removeFromDir(i) = 1;
    end                
end

removeFromDir = logical(removeFromDir);
direc(removeFromDir) = [];

fileNames = {direc(:).name};
for i = 1:length(fileNames);
    extract = char(fileNames{i});
    if strcmp(extract(1:3),'rem');
        remFromDir(i) = 1;
    else
        remFromDir(i) = 0;
    end
end
remFromDir = logical(remFromDir);
direc(remFromDir) = [];
    