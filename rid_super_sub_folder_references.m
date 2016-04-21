% rid_super_sub_folder_references.m - function for getting rid of '.' and
% '..' directores in the matlab dir structure; only really relevant on UNIX

function d = rid_super_sub_folder_references(d)

toRemove = zeros(1,length(d)); % preallocate
for i = 1:length(d);
    if strcmp(d(i).name,'.') || strcmp(d(i).name,'..')
        toRemove(i) = 1;
    end
end

d(logical(toRemove)) = [];

