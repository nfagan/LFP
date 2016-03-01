function plex = getPlexonDataTest(plexFile,channelName)

[adfreq, n, ts, fn, ad] = plx_ad_v(plexFile.name, 'WB09'); %Plexon SDK
idTimes = ts + (1 / adfreq)*(1:length(ad));

for i = 1:3;
newTs{i} = PL2Ts(plexFile.name,channelName,i);

end

% newTs = PL2Ts(plexFile.name,channelName,1);

spikes = zeros(length(ad),1);

for i = 1:length(newTs);
    useTs = newTs(i);
    currentTime = useTs;
    [N,index] = histc(currentTime,idTimes); clear N;
    check = abs(currentTime - idTimes(index)) < abs(currentTime-idTimes(index+1));
    if ~check
        index = index+1;    
    end         
    spikes(index) = 1;
end;

[event] = PL2EventTs(plexFile.name,'Strobed');
strobed = int32(event.Strobed); %make integer (originally stored as double)
reformatted = double(bitand(strobed,127)); %take right 7 bits only -- only meaningful bits

reformatted(:,2) = event.Ts;

%plexon outputs
plex.adfreq = adfreq;
plex.tStamps = newTs;
plex.n = n;
plex.ts = ts;
plex.fn = fn;
plex.ad = spikes;
plex.idTimes = idTimes;
plex.reformatted = reformatted;

