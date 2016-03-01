function h = spectrogramOneTrial(power,frequency,trialN,maxFrequency)

clims = [0 6e4];

for i = 1:length(power);
    
oneWindowPower = power{i};
oneWindowFreq = frequency{i};

if size(oneWindowPower,2) > 1;
    toPlotPower = oneWindowPower(:,trialN);
    toPlotFreq = oneWindowFreq(:,1);
else
    toPlotPower = oneWindowPower;
    toPlotFreq = oneWindowFreq;
end

if nargin>3

freqIndex = toPlotFreq<maxFrequency;

spectPower(:,i) = toPlotPower(freqIndex);
spectFreq(:,i) = toPlotFreq(freqIndex);

else    
    spectPower(:,i) = toPlotPower;
    spectFreq(:,i) = toPlotFreq;
end

end

if nargin>3

for k = 1:size(spectFreq,1);
    toLabel{k} = num2str(spectFreq(k,1));
end

end

h = imagesc(spectFreq,'CData',spectPower,clims);
% h = imagesc(spectFreq,'CData',spectPower);
h = colorbar; ylabel(h, 'Power (dB)');

if nargin>3

ax = gca;
ax.YTickLabel = toLabel;

end

ylabel('hz'); xlabel('Time');
    



