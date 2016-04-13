function h = spectrogramOverTime4(power,frequency,maxFrequency,trialNumber,trialByTrial,stepSize,startEnd,clims)

% minFrequency = 10;
minFrequency = 0;
printFig = 0;
toSmooth = 0;
doFilter = 1;
flipChart = 1;

for i = 1:length(power);
    
oneWindowPower = power{i};
oneWindowFreq = frequency{i};

if (size(oneWindowPower,2) > 1) && (~trialByTrial);
    toPlotPower = mean(oneWindowPower,2);
    toPlotFreq = oneWindowFreq(:,1);
else
    toPlotPower = oneWindowPower;
    toPlotFreq = oneWindowFreq;
end

if nargin>2

% freqIndex = toPlotFreq<maxFrequency & toPlotFreq > minFrequency;

    if ~trialByTrial;

%     freqIndex = toPlotFreq<maxFrequency;
    freqIndex = (toPlotFreq<maxFrequency) & (toPlotFreq>minFrequency);

    spectPower(:,i) = toPlotPower(freqIndex);
    spectFreq(:,i) = toPlotFreq(freqIndex);

    else 

%         freqIndex = toPlotFreq<maxFrequency;
        freqIndex = (toPlotFreq<maxFrequency) & (toPlotFreq>minFrequency);

        spectPower(:,i) = toPlotPower(freqIndex,trialNumber);
        spectFreq(:,i) = toPlotFreq(freqIndex);
        
    end

else
    
    spectPower(:,i) = toPlotPower;
    spectFreq(:,i) = toPlotFreq;

end

end

if nargin>2

for k = 1:size(spectFreq,1);
    toLabel{k} = num2str(round(spectFreq(k,1)));
end

end

% h = imagesc(spectFreq,'CData',spectPower,clims);

if toSmooth

% for jj = 1:size(spectPower,1);
%     spectPower(jj,:) = smooth(spectPower(jj,:),'sgolay');
% end

for jj = 1:size(spectPower,2);
    spectPower(:,jj) = smooth(spectPower(:,jj),'sgolay');
end


end %end toSmooth


if doFilter
   
if flipChart
    spectFreq = flipud(spectFreq);
    spectPower = flipud(spectPower);
end

% filterTest = fspecial('gaussian',[3 3], 0.5);
% filteredImage = imfilter(combinedArray, filterTest, 'replicate');
B = imgaussfilt(spectPower,2);

if ~isempty(clims);

    h = imagesc(spectFreq,'CData',B,clims);
else
    h = imagesc(spectFreq,'CData',B);
end
ylabel('Power (dB)');

else
    if flipChart
        spectFreq = flipud(spectFreq);
        spectPower = flipud(spectPower);
    end
% h = imagesc(spectFreq,'CData',spectPower);

if ~isempty(clims);
    h = imagesc(spectFreq,'CData',spectPower,clims);
else
    h = imagesc(spectFreq,'CData',spectPower);
end

ylabel('Power (dB)');

end


d = colorbar; 
% colorbar;
colormap('jet');
map = colormap;
c = map(24:end,:);
colormap(c);

% ylabel(h, 'Z Score');
ylabel(d, 'Normalized Power');

if nargin>2

    if flipChart
        toLabel = fliplr(toLabel);
    end
    
ax = gca;
ax.YTick = 1:size(spectFreq,1);
ax.YTickLabel = toLabel;

if length(power) == 40;
    timeSeries = -1000:50:1000;
    timeSeries(end) = [];    
    for j = 1:4:length(timeSeries)-1;
        timeSeriesAxis{j} = num2str(timeSeries(j));
        timeSeriesAxis{j+1} = '';
        timeSeriesAxis{j+2} = '';
        timeSeriesAxis{j+3} = '';
    end
    
    ax = gca;
    ax.XTick = 1:40;
    ax.XTickLabel = timeSeriesAxis;
    
else
    
%     timeSeries = -1000:stepSize:1000;
%     timeSeries = -250:stepSize:1750;
    timeSeries = startEnd(1):stepSize:startEnd(2);
    
    if stepSize == 50;
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
        
    else
        
        for j = 1:20:length(timeSeries);
            if j < length(timeSeries);
                timeSeriesAxis{j} = num2str(timeSeries(j));
                timeSeriesAxis{j+1} = '';
                timeSeriesAxis{j+2} = '';
                timeSeriesAxis{j+3} = '';
                timeSeriesAxis{j+4} = '';
                timeSeriesAxis{j+5} = '';
                timeSeriesAxis{j+6} = '';
                timeSeriesAxis{j+7} = '';                
                timeSeriesAxis{j+8} = '';    
                timeSeriesAxis{j+9} = '';    
                timeSeriesAxis{j+10} = ''; 
                timeSeriesAxis{j+11} = ''; 
                timeSeriesAxis{j+12} = ''; 
                timeSeriesAxis{j+13} = ''; 
                timeSeriesAxis{j+14} = ''; 
                timeSeriesAxis{j+15} = ''; 
                timeSeriesAxis{j+16} = ''; 
                timeSeriesAxis{j+17} = ''; 
                timeSeriesAxis{j+18} = ''; 
                timeSeriesAxis{j+19} = ''; 
            else
                timeSeriesAxis{j} = num2str(timeSeries(j));
            end
        end
        
    end
    
    ax = gca;
    ax.XTick = 1:length(timeSeries);
    ax.XTickLabel = timeSeriesAxis;
    
end
    

end

ylabel('hz'); xlabel('Time');

if printFig

% cd /Users/Nick/Desktop/FIGURE_OUTPUT/Spectrogram/targ/Periodogram;
% cd /Users/Nick/Desktop/FIGURE_OUTPUT/Spectrogram/zscore;
cd /Users/Nick/Desktop/FIGURE_OUTPUT/Spectrogram/fixed_alignment;

% name1 = num2str(trialNumber);
name1 = 'SELF_ACC_Target_acquire';
print(name1,'-despc');
% print(name1,'-dpng');

end
    



