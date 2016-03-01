% spikeTS = plex.tStamps;
spikeTS = plex.tStamps{3};
eventTS = allTimes(:,5);
minT = -3;
maxT = 3;
binWidth = .005;

[psth, binT, nTrials] = loopyPSTH(spikeTS, eventTS, minT, maxT, binWidth);
psth = smooth(psth,20);

plot(psth);

zeroInd = find(binT == 0); zeroInd(2) = zeroInd;
plotY = [0 max(psth)+1];
hold on;
plot(zeroInd,plotY,'k')
disp(nTrials);