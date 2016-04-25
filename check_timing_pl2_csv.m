% function check_timing_pl2_csv.m - checks whether the .pl2-.csv file
% pairs appear to be formatted properly for use with load_signals.m. If
% valid = 0, the function believes that data in the listed folder will not be
% suitable for load_signals.m. If valid = 2, the data may or may not be
% valid; running with this folder intact is worth a shot

function valid = check_timing_pl2_csv(umbrellaDirectory,withSubfolders,removeRem)

escape = 0;

if nargin < 2
    withSubfolders = 1; % true if .csv files and .pl2 files are already organized
                        % into subfolders
    removeRem = 0;
elseif nargin < 3
    removeRem = 0;
end

cd(umbrellaDirectory);

while escape == 0 % if directory has no subfolders, assume withSubfolders was
                  % mistakenly input
    if withSubfolders
        umbrDir = rid_super_sub_folder_references(dir); % get rid of '.' and '..'
        umbrDir(~logical(cell2mat({umbrDir(:).isdir}))) = []; % get rid of non-folders
            if isempty(umbrDir)
                withSubfolders = 0;
            else
                escape = 1;
            end
    else % the umbrellaDirectory has all the files in it
        umbrDir(1).name = umbrellaDirectory;
        escape = 1;
    end
end

if removeRem % if ignoring directories prefixed with 'rem'
    umbrDir = remDir(umbrDir);
end

step = 1; storeMessage = []; valid = [];
for i = 1:length(umbrDir);
    cd(umbrDir(i).name);
    
    csvDir = remDir(dir('*.csv'),'n');
    pl2Dir = remDir(dir('*.pl2'),'n');
    
    nCSV = length(csvDir);
    nPL2 = length(pl2Dir);
    
    if nCSV ~= nPL2 || nCSV == 0
        storeMessage{step} = sprintf(['\nThere is not an equal number of .pl2' ...
            , ' and .csv files in the folder\n (%s), and\n this folder will' ...
            , ' be skipped from further checking.'],umbrDir(i).name);
        step = step+1;
    else
        for k = 1:nCSV
            try
                csvFile = csvread(csvDir(k).name);
            catch
                csvFile = csvread(csvDir(k).name,1);
            end
            
            [event] = PL2EventTs(pl2Dir(k).name,'Strobed');
            strobed = int32(event.Strobed); %make integer (originally stored as double)
            reformatted = double(bitand(strobed,127)); %take right 7 bits only -- only meaningful bits
            reformatted(:,2) = event.Ts;
            
            if size(reformatted,1) ~= size(csvFile,1)
                if size(reformatted,1) < size(csvFile,1);
                    txtDir = dir('*.txt'); % check if there's a .txt file index of
                                           % which strobed-times correspond
                                           % to which .csv Picto times
                    if ~isempty(txtDir);
                        storeMessage{step} = sprintf(['\nIn the folder (%s), the current .pl2 file\n(%s)' ...
                            , ' does not encompass the full\nPicto session (%s)' ...
                            , ',\nbut still ought to work with load_signals, because' ...
                            , ' there is \na .txt-file index associated with it.'],...
                            umbrDir(i).name,pl2Dir(k).name,csvDir(k).name);
                            step = step+1;
                            valid(step) = 2;
                    else
                        storeMessage{step} = sprintf(['\nIn the folder (%s), the current .pl2 file\n(%s)' ...
                            , ' does not encompass the full\nPicto session (%s)' ...
                            , ',\nand does not have a .txt file index associated with it.' ...
                            , '\nThis folder will not work with load_signals.m'],...
                            umbrDir(i).name,pl2Dir(k).name,csvDir(k).name);
                            step = step+1;
                            valid(step) = 3;
                    end
                else
                    storeMessage{step} = sprintf(['\nIn the folder (%s), the current .pl2 file\n(%s)' ...
                        , ' has more timing data than the\nPicto session file (%s)' ...
                        , ', and will not work with load_signals (as is).'],...
                        umbrDir(i).name,pl2Dir(k).name,csvDir(k).name);
                    step = step+1;
                    valid(step) = 3;
                end
            else
                storeMessage{step} = sprintf(['\nIn the folder (%s), the current .pl2 file''s\n(%s)' ...
                        , ' timing data matches that of Picto''s (%s).\n' ...
                        , ' This .pl2-.csv pair should work with load_signals'],...
                        umbrDir(i).name,pl2Dir(k).name,csvDir(k).name);
                    step = step+1;
            end
        end
    end
    cd ..; % escape from subfolder to umbrellaDirectory
end

for i = 1:length(storeMessage);
    fprintf('\n%s',storeMessage{i});
end

if sum(valid == 3) >= 1; % 3 -- invalid
    valid = 0;
elseif sum(valid == 2) >= 1;
    valid = 2;
else
    valid = 1;
end

    
    
    


