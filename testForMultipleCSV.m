function newCsvDir = testForMultipleCSV(csvDir,d)

formatIn = 'hh_mm_ss';

names = {csvDir(:).name};
for i = 1:length(names);
    oneName = fliplr(names{i});
    dateStr = fliplr(oneName(5:12));
    csvTimes(i) = datenum(dateStr,formatIn);
end

dNames = {d(:).name};

for i = 1:length(dNames)
    oneName = fliplr(dNames{i});
    dateStr = fliplr(oneName(1:8));
    folderTimes(i) = datenum(dateStr,formatIn);
end;

for i = 1:length(csvTimes);
    oneTime = csvTimes(i);   
    belowIndex(i,:) = oneTime < folderTimes;
    aboveIndex(i,:) = oneTime > folderTimes;
end;




    






