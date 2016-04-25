function prep_for_time_indexing(umbrDir)

subFolderDir = remDir(only_folders(rid_super_sub_folder_references(dir(umbrDir))));

for i = 1:length(subFolderDir);
    subFolderPath = fullfile(umbrDir,subFolderDir(i).name);
    cd(subFolderPath);
    
    pl2Dir = dir('*.pl2');
    pl2Names = lower({pl2Dir(:).name}');
    
    foundLabel = zeros(1,length(pl2Names));
    for k = 1:length(pl2Names);
        pre = strfind(pl2Names{k},'pre');
        if ~isempty(pre) % if pre is in the .pl2 file name
            foundLabel(k) = 1;
            newFileName = [num2str(1) '_' pl2Names{k}];
            movefile(pl2Names{k},newFileName);
        else
            post = strfind(pl2Names{k},'post');
            if ~isempty(post);
                foundLabel(k) = 1; 
                newFileName = [num2str(2) '_' pl2Names{k}];
                movefile(pl2Names{k},newFileName);
            end
        end
    end
    
    if sum(foundLabel) ~= length(pl2Names);
        fprintf('\nWARNING: could not properly label all the picto folders in the subfolder %s',subFolderDir(i).name);
    end
    
    behavDataDir = remDir(only_folders(rid_super_sub_folder_references(dir(subFolderPath))));
    if length(behavDataDir) == 1;
        behavDataPath = fullfile(subFolderPath,behavDataDir(1).name);
        pictoFolders = remDir(only_folders(rid_super_sub_folder_references(dir(behavDataPath))));
        origPictoFolders = {pictoFolders(:).name}';
        pictoFolders = lower({pictoFolders(:).name}');
        for k = 1:length(pictoFolders);
            pre = strfind(pictoFolders{k},'pre');
            if ~isempty(pre)
                foundLabel(k) = 1;
                newFolderName = [num2str(1) '_' origPictoFolders{k}];
                movefile(fullfile(behavDataPath,origPictoFolders{k}),fullfile(behavDataPath,newFolderName));
            else
                post = strfind(pictoFolders{k},'post');
                if ~isempty(post)
                    foundLabel(k) = 1;
                    newFolderName = [num2str(2) '_' origPictoFolders{k}];
                    movefile(fullfile(behavDataPath,origPictoFolders{k}),fullfile(behavDataPath,newFolderName));
                end
            end
        end
           
    else
        fprintf(['\nWARNING: No behavioral data was found in the subfolder %s' ...
            , ' and it will be skipped.'],subFolderDir(i).name);
    end
    
    if sum(foundLabel) ~= length(pictoFolders);
        fprintf('\nWARNING: could not properly label all the picto folders in the subfolder %s',subFolderDir(i).name);
    end
    
end
        
    
    
    
    
    
    