function d = remDir(d)
names ={d(:).name}';
for i = 1:length(names)
    oneName = char(names{i});
    
    if strcmp(oneName(1:3),'rem');
        remIndex(i) = 1;
    else
        remIndex(i) = 0;
    end
end

remIndex = logical(remIndex);
d(remIndex) = [];
    
    
    
