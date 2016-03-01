y(1:length(saveIndex)) = 1;

plot(saveIndex,y,'*')
hold on;

spikes = plex.ad;

plot(spikes);