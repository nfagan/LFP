function h = spectrogramOverTime2(power,frequency,maxFrequency,trialNumber)

trialByTrial = 1;

toSmooth = 1;

% clims = [-4 2];

for i = 1:length(power);
    
oneWindowPower = power{i};
oneWindowFreq = frequency{i};

if size(oneWindowPower,2) > 1;
    toPlotPower = mean(oneWindowPower,2);
    toPlotFreq = oneWindowFreq(:,1);
else
    toPlotPower = oneWindowPower;
    toPlotFreq = oneWindowFreq;
end

if nargin>2

% freqIndex = toPlotFreq<maxFrequency & toPlotFreq > minFrequency;

    if ~trialByTrial;

    freqIndex = toPlotFreq<maxFrequency;

    spectPower(:,i) = toPlotPower(freqIndex);
    spectFreq(:,i) = toPlotFreq(freqIndex);

    else 

        freqIndex = toPlotFreq<maxFrequency;

        spectPower(:,i) = toPlotPower(freqIndex,trialNumber);
        spectFreq(:,i) = toPlotFreq(freqIndex,trialNumber);
        
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
    spectPower(:,jj) = smooth(spectPower(:,jj),8,'sgolay');
end


end %end toSmooth

% spectPower = smooth(spectPower);

h = imagesc(spectFreq,'CData',spectPower);
h = colorbar; 
colormap('jet');

% ylabel(h, 'Power (dB)');
% ylabel(h, 'Z Score');
ylabel(h, 'Normalized Power');


if nargin>2

ax = gca;
ax.YTick = 1:size(spectFreq,1);
ax.YTickLabel = toLabel;

end

ylabel('hz'); xlabel('Time');
    



