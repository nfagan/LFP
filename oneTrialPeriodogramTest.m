hold off;
oneTrial = 1;
trialN = 50;

signalPerWindow = concatenatedSignals{1}; %get current time window's signal

if oneTrial

[pxx,w] = doMultitaper(signalPerWindow,0);
    
[nonTaperedPower,nonTaperedFreq] = doPeriodogram(signalPerWindow,0);
    
pxx = 10*log10(pxx); %convert to dB
nonTaperedPower = 10*log10(nonTaperedPower);    

plotPxx = pxx(:,trialN);
plotNonTapered = nonTaperedPower(:,trialN);

hold on;

plot(w,plotPxx); plot(nonTaperedFreq,plotNonTapered,'k');

else
    
[pxx,w] = doMultitaper(signalPerWindow,0);
    
[nonTaperedPower,nonTaperedFreq] = doPeriodogram(signalPerWindow,0);  
pxx = 10*log10(pxx); %convert to dB
nonTaperedPower = 10*log10(nonTaperedPower);

plot(w,pxx); 
plot(nonTaperedFreq,nonTaperedPower);
end
    
    
