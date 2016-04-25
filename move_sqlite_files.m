function move_sqlite_files(umbrellaDirectory)

subfolders = remDir(only_folders(rid_super_sub_folder_references(dir(umbrellaDirectory))));

for i = 1:length(subfolders);
    folderPath = fullfile(umbrellaDirectory,subfolders(i).name);
    cd(folderPath);
    
    sqlDir = dir('*.sqlite');
    
    foundSqlFile = 0;
    
    if isempty(sqlDir)
        behavFolder = only_folders(rid_super_sub_folder_references(dir(cd)));
        if isempty(behavFolder)
            error('No behavioral data were found in the subfolder %s',folderPath);
        else
            while ~foundSqlFile && k <= length(behavFolder)
                cd(fullfile(folderPath,behavFolder(k).name));
                sqlDirSubFolder = dir('*.sqlite');
                if ~isempty(sqlDirSubFolder)
                    foundSqlFile = 1;
                else
                    k = k+1;
                end
            end
            
            if foundSqlFile
                for j = 1:length(sqlDirSubFolder);
                    sqlFile = sqlDirSubFolder(j).name;
                    destination = fullfile(folderPath,sqlFile);
                    copyfile(sqlFile,destination);
                end
            else
                fprintf(['\NWARNING: Could not find any .sqlite files in the' ...
                    , ' subfolder %s'],folderPath);
            end
        end
    else
        fprinf('\nA .sqlite file was found in the correct place in subfolder %s', ...
            folderPath)
    end
        
end
            
        
        
    
    
    
    

