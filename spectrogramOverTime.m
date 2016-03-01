function h = spectrogramOverTime(power,frequency)

for i = 1:length(power);
    onePower = power{i};
    oneFreq = frequency{i};
    
%     meanonePower = mean(onePower,2);
        
%     toPlotPower(:,i) = meanonePower;
    toPlotPower(:,i) = onePower;
    toPlotFrequency(:,i) = oneFreq;       
        
    clear meanOnePower oneFreq
    
end

% clims = [-130 0];
clims = [-2 4];

h = imagesc(toPlotFrequency,'CData',toPlotPower,clims);
h = colorbar; ylabel(h, 'Power (dB)');
xlabel('Time'); ylabel('Frequency (hz)');

% ylim([0 100]);
ylim([0 4]);

colormap('jet');




% h = imagesc(x,toPlotFrequency,toPlotPower);



    

    




