function plex = getPlexonData(plexFile,channelName)

global samplingRate;

[adfreq, n, ts, fn, ad] = plx_ad_v(plexFile.name, channelName); %Plexon SDK
idTimes = ts + (1 / adfreq)*(1:length(ad));

if ~isempty(samplingRate)
    integerFactor = adfreq/samplingRate; % determine the factor by which
                                         % to downsample to get to our
                                         % desired sampling rate
else
    integerFactor = 1; % otherwise, don't downsample
end

ad = downsample(ad,integerFactor); % replace raw neuraldata with downsampled data
idTimes = downsample(idTimes,integerFactor); % do the same but with the idTimes
adfreq = samplingRate; % replace old sampling rate with new sampling rate

[event] = PL2EventTs(plexFile.name,'Strobed');
strobed = int32(event.Strobed); %make integer (originally stored as double)
reformatted = double(bitand(strobed,127)); %take right 7 bits only -- only meaningful bits

reformatted(:,2) = event.Ts;
% reformatted(:,3:6) = M;

% store plexon outputs
plex.adfreq = adfreq;
plex.n = n;
plex.ts = ts;
plex.fn = fn;
plex.ad = ad;
plex.idTimes = idTimes;
plex.reformatted = reformatted;

