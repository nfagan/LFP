function create_folder_structure(umbrDir,requireInput)

if nargin < 2
    requireInput = 1;
end

subFolderDir = remDir(only_folders(rid_super_sub_folder_references(dir(umbrDir))));

for i = 1:length(subFolderDir);
    
    subFolderPath = fullfile(umbrDir,subFolderDir(i).name);
    cd(subFolderPath)
    
    pl2Dir = dir('*.pl2');
    csvDir = dir('*.csv');
    
    if length(pl2Dir) > 1
        for k = 1:length(pl2Dir);
            pl2Names = {pl2Dir(:).name}';
            pl2Name = pl2Names{k};
            
            fileIndex = pl2Name(1);
            
            newFolderName = [fileIndex '_' subFolderDir(i).name];
            newFolderPath = fullfile(umbrDir,newFolderName);
            fprintf('\nCreating new folder %s ... ',newFolderPath)
            
            mkdir(newFolderPath);
            
            % copy relevant .pl2 files, and .csv files ...
            
            for l = 1:length(pl2Names);
                if strncmpi(pl2Names{l},fileIndex,1) % if .pl2 file matches 
                                                     % file index, move it
                                                     % to the new folder
                    source = fullfile(subFolderPath,pl2Names{l});
                    destination = fullfile(newFolderPath,pl2Names{l});
                    copyfile(source,destination);
                    if length(csvDir) > 1
                        fprintf(['\nWARNING: There''s more than one .csv file' ...
                            , ' in the subfolder %s, and only the first will be copied to the new folder.'],...
                            subFolderDir(i).name);
                    elseif isempty(csvDir)
                        fprintf(['\nWARNING: No .csv file was found' ...
                            , ' in the subfolder %s, and none will be copied to the new folder.'],...
                            subFolderDir(i).name);
                    else
                        sourceCSV = fullfile(subFolderPath,csvDir(i).name);
                        destinCSV = fullfile(newFolderPath,csvDir(i).name);
                        copyfile(sourceCSV,destinCSV);
                    end
                        
                end
            end
            
            % copy relevant .txt files ...
            
            txtFileNames = dir('*.txt');
            txtFileNames = {txtFileNames(:).name};
            
            for l = 1:length(txtFileNames); % same story, but with .txt files
                if strncmpi(txtFileNames{l},fileIndex,1);
                    source = fullfile(subFolderPath,txtFileNames{l});
                    destination = fullfile(newFolderPath,txtFileNames{l});
                    copyfile(source,destination);
                end
            end
            
            % copy relevant picto data ...
            
            newBehavDataPath = fullfile(newFolderPath,'behavioral data');
            mkdir(newBehavDataPath); % make a new sub-directory
            
            behavDataDir = remDir(only_folders(rid_super_sub_folder_references(...
                dir(subFolderPath))));
            if length(behavDataDir) == 1;
                behavDataPath = fullfile(subFolderPath,behavDataDir(1).name);
                behaveFolders = remDir(only_folders(rid_super_sub_folder_references(...
                    dir(behavDataPath))));
                behaveFolders = {behaveFolders(:).name}';
                for l = 1:length(behaveFolders)
                    if strncmpi(behaveFolders{l},fileIndex,1)
                        source = fullfile(behavDataPath,behaveFolders{l});
                        destination = fullfile(newBehavDataPath,behaveFolders{l});
                        copyfile(source,destination);
                    end
                end
            elseif length(behavDataDir) > 1;
                warning(['More than one potential behavioral data directory' ...
                    , ' exists for the subfolder %s, and it will be skipped.'],...
                    subFolderDir(i).name)
            else
                warning(['No behavioral data directory could be found' ...
                    , ' in the subfolder %s, and it will be skipped.'],...
                    subFolderDir(i).name)
            end
        end 
                            % now delete the old folder, after creating the
                            % new folders
        if requireInput
            prompt = sprintf('\nThe old folder %s will now be deleted. Proceed (y/n)?',...
                subFolderPath);
            inp = input(prompt,'s');
        else
            inp = 'y';
        end
        
        if strcmp(inp(1),'y');
            rmdir(subFolderPath,'s');
        elseif strcmp(inp(1),'n')
            fprintf('\nNot deleting %s ...',subFolderPath);
        else
            if strcmp(inp,'abort');
                error('User aborted');
            end
        end
            
    elseif isempty(pl2Dir)
        error('No .pl2 files exist in the subfolder %s',subFolderDir(i).name);
    else
        fprintf('\nSkipping the subfolder %s because it only has one .pl2 file in it.',subFolderDir(i).name);
            
    end
end
    
