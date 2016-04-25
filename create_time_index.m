% create_time_index.m - function for obtaining the index of the subset of
% reference times (for a given recording session's .sqlite file) that
% correspond to each .pl2 file's strobed-times. Must be run after
% generating .csv files via get_timing_csv_files.py, *and* assumes that the
% .pl2 files have not yet been separated into individual sub-folders. I.e.,
% it assumes that each folder in your umbrellaDirectory has more than one
% .pl2 file, and that each .pl2 file is tagged with a number corresponding to
% its order in the session (e.g. '1_kuro_saline.pl2','2_kuro_saline.pl2'); 

function create_time_index(umbrDir)

cd(umbrDir);
                                                    % only get non-rem
                                                    % prefixed folders in
                                                    % current directory:
                                                    
fixedDir = only_folders(remDir(rid_super_sub_folder_references(dir)));

for i = 1:length(fixedDir) % for each session folder ...
    cd(fullfile(umbrDir,fixedDir(i).name));
    
    csvDir = remDir(dir('*.csv')); % get the name of the .csv file
    pl2Dir = remDir(dir('*.pl2')); % get the names of the .pl2 files
    
    if isempty(csvDir);
        error('No .csv file present for this subfolder (%s)',fixedDir(i).name);
    elseif length(pl2Dir) == 1;
        warning(['There''s only 1 .pl2 file in this subfolder (%s),\nwhich we' ...
            , ' will assume to encompass the full Picto recording session.' ...
            , '\nThis folder will be skipped from further analysis'],fixedDir(i).name)
    else
        try
            csvFile = csvread(csvDir(1).name);
        catch
            csvFile = csvread(csvDir(1).name,1); % if .csv file has string
                                                 % column headers, remove
                                                 % them
        end        
        
        if size(csvFile,2) < 3 % regenerate the .csvs with the new version
                               % of get_timing_csv_files.py if you get this
                               % error!
            error('csvFile is missing an aligncode.');
        end
        
        for k = 1:length(pl2Dir); % for each .pl2 file ...
            if length(pl2Dir) > 1 && k < length(pl2Dir)
                if pl2Dir(k).datenum > pl2Dir(k+1).datenum
                    warning('You might have the wrong order for the .pl2 files');
                                        % We manually identify the order of the .pl2
                                        % files, because there's no
                                        % guarentee that they were saved
                                        % sequentially. HOWEVER, they *probably* were saved
                                        % sequentially, so if our ordering doesn't
                                        % match the date-num order, throw a
                                        % warning
                end
            end
            
            [event] = PL2EventTs(pl2Dir(k).name,'Strobed'); % get strobed-times (b/w Plexon & Picto)
            strobed = int32(event.Strobed); % make integer (originally stored as double)
            reformatted = double(bitand(strobed,127)); % take right 7 bits only
            reformatted = [reformatted repmat(k,length(reformatted),1)]; % include file id
            
            if k < 2
                storePlexTimes = reformatted;
            else
                if reformatted(1,1)-1 == storePlexTimes(end,1)
                    storePlexTimes = [storePlexTimes;reformatted];
                else % for this to work as is, we must assume that the align code
                     % associated with each subsequent .pl2's time zero is
                     % the *next integer align code in the series 1-127
                     % after the preceding .pl2's file end time align code
                     % Otherwise, throw an error (for now), while we work
                     % out a new way to align these.
                    error('The plexon files do not form a continuous time series');
                end
            end
            
        end
        
        csvFile = flipud(csvFile); % flip things to prep for zero-padding
                                   % the difference in length between the
                                   % picto .csv and plex strobed-times
        storePlexTimes = flipud(storePlexTimes);
        
        plexSize = size(storePlexTimes,1);
        csvSize = size(csvFile,1);
        
        if csvSize < plexSize
            error('There''s more neural data than behavioral data, and this method won''t work as is.');
        else
            storePlexTimes(plexSize+1:csvSize,:) = 0;
            storePlexTimes = flipud(storePlexTimes);
            for k = 1:length(pl2Dir);
                fileName = sprintf('%d_time_index.txt',k);
                fileName = fullfile(umbrDir,fixedDir(i).name,fileName);
                onePl2Index = storePlexTimes(:,2) == k;
                dlmwrite(fileName,onePl2Index);
            end
        end          
    end
end
