function add_rem(umbrDir,addRem,exclude)

if nargin < 2;
    addRem = 1;
    exclude = [];
elseif nargin < 3;
    exclude = [];
end

subFolders = only_folders(rid_super_sub_folder_references(dir(umbrDir)));

for i = 1:length(subFolders);
    include = 1;
    folderName = subFolders(i).name;
    
    if ~isempty(exclude);
        if any(strcmp(folderName,exclude));
            include = 0;
        end
    end    
    
    if ~strncmpi(folderName,'rem',3) && addRem && include
        sourcePath = fullfile(umbrDir,folderName);
        folderName = ['rem_' folderName];
        destinationPath = fullfile(umbrDir,folderName);
        movefile(sourcePath,destinationPath);
    elseif strncmpi(folderName,'rem',3) && ~addRem && include
        sourcePath = fullfile(umbrDir,folderName);
        folderName = folderName(~strncmpi(folderName,'rem_',4));
        destinationPath = fullfile(umbrDir,folderName);
        movefile(sourcePath,destinationPath);
    end
end