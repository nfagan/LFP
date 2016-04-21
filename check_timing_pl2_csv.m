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

if removeRem
    umbrDir = remDir(umbrDir);
end

step = 1; storeMessage = [];
for i = 1:length(umbrDir);
    cd(umbrDir(i).name);
    
    csvDir = remDir(dir('*.csv'),'n');
    pl2Dir = remDir(dir('*.pl2'),'n');
    
    nCSV = length(csvDir);
    nPL2 = length(pl2Dir);
    
    if nCSV ~= nPL2 || nCSV == 0
        storeMessage{step} = sprintf(['There is not an equal number of .pl2' ...
            , ' and .csv files in the current folder\n\t (%s), and\n\t this folder will' ...
            , ' be skipped from further checking.'],umbrDir(i).name);
        step = step+1;
    else
        for k = 1:length(csvDir);
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
                    storeMessage{step} = sprintf(['In the folder (%s), the current .pl2 file (%s)' ...
                        , ' does not encompass the full Picto session (%s)' ...
                        , ', but still ought to work with load_signals.'],...
                        umbrDir(i).name,pl2Dir(k).name,csvFile(k).name);
                    step = step+1;
                else
                    storeMessage{step} = sprintf(['In the folder (%s), the current .pl2 file (%s)' ...
                        , ' has more timing data than the Picto session file (%s)' ...
                        , ', and will not work with load_signals (as is).'],...
                        umbrDir(i).name,pl2Dir(k).name,csvFile(k).name);
                    step = step+1;
                end
            end
        end
    end
    cd ..; % escape from subfolder to umbrellaDirectory
end

if isempty(storeMessage);
    fprintf('\nThe .csv-.pl2 pairs appear valid and able to work with load_signals.m');
    valid = 1;
else
    for i = 1:length(storeMessage);
        fprintf('\n%s',storeMessage{i});
    end
    valid = 0;
end

    
    
    


