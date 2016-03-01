function lineNoiseRemovedLFP = removeLineNoise(allLFP)

for i = 1:length(allLFP);

extractLFP = allLFP{i};

params.tapers = [3 5];
params.Fs = 1000;

fixedData=rmlinesc(extractLFP,params,'n');

lineNoiseRemovedLFP{i} = fixedData;

end