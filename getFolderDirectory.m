function folderDirectory = getFolderDirectory(umbrellaDirectory)
d = dir(umbrellaDirectory);

nameCheck = {d(:).name};

for i = 1:length(nameCheck);
    
    oneCheck = char(nameCheck{i});
    
    if length(oneCheck) < 3;
        sizeCheck(i) = 1;
        remCheck(i) = 0;
    else
        sizeCheck(i) = 0;
        if strcmp(oneCheck(1:3),'rem');
            remCheck(i) = 1;
        else
            remCheck(i) = 0;
        end
    end;
end

remCheck = logical(remCheck');
sizeCheck = logical(sizeCheck');
sizeCheck = sizeCheck | remCheck;
d(sizeCheck) = [];

dirCheck = logical(cell2mat({d(:).isdir}'));
d(~dirCheck) = [];

folderDirectory = d;
