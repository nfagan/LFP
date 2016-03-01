function h = coherenceOverTime(coherence,freq,maxFreq,clims,doGaussFilter)

addSmoothing = 0;

if iscell(coherence);
    error('Coherence cannot be a cell array');
    return;
end

%get rid of values above max frequency
freqInd = freq(:,1) > maxFreq;

coherence(freqInd,:) = [];
freq(freqInd,:) = [];

if (size(coherence,2) ~= size(freq,2)) && (size(freq,2) < size(coherence,2))
    for j = 2:size(coherence,2);
        freq(:,j) = freq(:,1);
    end
else
    error('Coherence must have same number of elements as frequency');
end


%get coherence over time
for i = 1:size(coherence,2);
    oneCoherence = coherence(:,i);
    if addSmoothing
        oneCoherence = smooth(oneCoherence);    
    end
    coherence(:,i) = oneCoherence;
end

%invert matrices
freq = flipud(freq);
coherence = flipud(coherence);

%gaussian blur
if doGaussFilter
    coherence = imgaussfilt(coherence,2);
end

%plot
if ~isempty(clims);
    h = imagesc(freq,'CData',coherence,clims);
else
    h = imagesc(freq,'CData',coherence);
end
colormap('jet');
% map = colormap; c = map(24:end,:); colormap(c);
d = colorbar;

%add labels

ylabel(d, 'Coherence');
ylabel('Frequency (hz)');
xlabel('Time from Target Acquire (ms)');

for k = 1:size(freq,1);
    toLabel{k} = num2str(round(freq(k,1)));
end
ax = gca;
ax.YTick = 1:size(freq,1);
ax.YTickLabel = toLabel;

if size(coherence,2) == 41;
    stepSize = 50;
else
    stepSize = 10;
end

timeSeries = -1000:stepSize:1000;

for j = 1:4:length(timeSeries);
    if j < length(timeSeries);
        timeSeriesAxis{j} = num2str(timeSeries(j));
        timeSeriesAxis{j+1} = '';
        timeSeriesAxis{j+2} = '';
        timeSeriesAxis{j+3} = '';
    else
        timeSeriesAxis{j} = num2str(timeSeries(j));
    end
end

ax = gca;
ax.XTick = 1:length(timeSeries);
ax.XTickLabel = timeSeriesAxis;








    
    