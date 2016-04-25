% only_folders.m - function for removing non-directory items from a
% directory struct

function d = only_folders(d)

d(~logical(cell2mat({d(:).isdir})')) = [];