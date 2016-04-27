function [power,frequency] = normPower(targSignals,fixSignals,functionType)

global samplingRate;

fs = samplingRate; % Sampling rate
freqs = 0:2:200; % Frequencies to look over

numMultitapers = 5; % Only relevant for multitapering
nw = (numMultitapers + 1)/2;

switch functionType
    case 'periodogram'
        functionN = 1;
    case 'multitaper'
        functionN = 2;        
end

oneFix = fixSignals{1}; oneFix = oneFix';

if functionN == 1;
    [baseP,baseF] = periodogram(oneFix,[],freqs,fs);
else
    [baseP,baseF] = pmtm(oneFix,nw);       
    baseF = (baseF.*fs)./(2*pi); % Convert from normalized freq to hz
end

baseP = mean(baseP,2); % Get the row-mean (per-trial mean) for the baseline-period

power = zeros(length(freqs),length(targSignals));

for i = 1:length(targSignals);
    disp(i);
    oneTarg = targSignals{i}; oneTarg = oneTarg'; % Get column vector of 
                                                  % one time-window's
                                                  % signals
    
    if functionN == 1;            
        [targP,targF] = periodogram(oneTarg,[],freqs,fs);
    else
        [targP,targF] = pmtm(oneTarg,nw);
        targF = (targF.*fs)./(2*pi);
    end;
    
    targP = mean(targP,2); % Get the row-mean (per-trial mean) for this 
                           % time-bin (time window)
    normPower = targP./baseP; % Normalize it by the baseline-power
    
    power(:,i) = normPower; % Store per-window
    
end

frequency = targF; % Only output one frequency vector, since it's the same 
                   % for all time windows
    
    
    