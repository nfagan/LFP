function rename_behavioral_data_folder(umbrDir)

subFolderDir = remDir(only_folders(rid_super_sub_folder_references(dir(umbrDir))));

for i = 1:length(subFolderDir)
    cd(fullfile(umbrDir,subFolderDir(i).name));
    
    behavioralDataDir = remDir(only_folders(rid_super_sub_folder_references(dir(cd))));
    
    if length(behavioralDataDir) == 1;
        if ~strcmp(behavioralDataDir(1).name,'behavioral data');
            destination = fullfile(umbrDir,subFolderDir(i).name,'behavioral data');
            movefile(behavioralDataDir(1).name,destination);
        else
            fprintf(['\nA ''behavioral data'' folder already exists in the correct place' ...
                , ' for the folder %s'],subFolderDir(i).name);
        end
    end
end
    