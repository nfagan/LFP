function d = remDir(d,verbose)

if nargin < 2; %by default, display warning messages about which folders 
               % will not be included
    verbose = 'verbose';
end

if ~isempty(d) %as long as d has at least one entry ...

names ={d(:).name}'; remIndex = zeros(1,length(names));
for i = 1:length(names)
    oneName = char(names{i});
    
    if strcmp(oneName(1:3),'rem');
        remIndex(i) = 1;
    end
end

remIndex = logical(remIndex);

toBeRemoved = d(remIndex); %for displaying which folders will be removed
if strcmp(verbose,'verbose'); %if opting to display warnings ...
    for i = 1:length(toBeRemoved);
        if i == 1;
            fprintf(['\n\nWARNING: data in the following folders or files will not be'...
                , ' loaded,\n\t because they have been prefixed with ''rem'':\n']);
        end
        fprintf('\n''%s''',toBeRemoved(i).name)
    end
end

d(remIndex) = [];

end
    
    
    
