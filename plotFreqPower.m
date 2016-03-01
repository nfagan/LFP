function h = plotFreqPower(power,frequency,windowNumber,trialNumber,freqLimits)

oneWindowPower = power{windowNumber};
oneWindowFreq = frequency{windowNumber};

if nargin > 3 && (size(oneWindowPower,2)>1)
    toPlotPower = oneWindowPower(:,trialNumber);
%     toPlotFreq = oneWindowFreq(:,trialNumber);
    toPlotFreq = oneWindowFreq(:,1);
else
    toPlotPower = oneWindowPower;
    
%     toPlotPower = 10*log10(toPlotPower);
    
    toPlotFreq = oneWindowFreq;
end


% toBin = 0:(500/10);
% toBin2 = 1:length(toPlotFreq)/length(toBin);

% for i = 1:length(toBin);
%     means = mean(toPlotPower(toBin(i):to
    



h = plot(toPlotFreq,toPlotPower);

xlabel('hz'); ylabel('dB');

if nargin>4
    xlim(freqLimits);
else   
xlim([0 50]);
end
    

