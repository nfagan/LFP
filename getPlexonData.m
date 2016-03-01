function plex = getPlexonData(plexFile,channelName)

[adfreq, n, ts, fn, ad] = plx_ad_v(plexFile.name, channelName); %Plexon SDK
% [ts] = PL2Ts(plexFile.name,channelName,1);

idTimes = ts + (1 / adfreq)*(1:length(ad));

[event] = PL2EventTs(plexFile.name,'Strobed');
strobed = int32(event.Strobed); %make integer (originally stored as double)
reformatted = double(bitand(strobed,127)); %take right 7 bits only -- only meaningful bits

reformatted(:,2) = event.Ts;
% reformatted(:,3:6) = M;

%plexon outputs
plex.adfreq = adfreq;
plex.n = n;
plex.ts = ts;
plex.fn = fn;
plex.ad = ad;
plex.idTimes = idTimes;
plex.reformatted = reformatted;

