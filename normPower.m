function [power,frequency] = normPower(targSignals,fixSignals,functionType)

fs = 40000;
freqs = 0:2:200;

numMultitapers = 5;    
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
    baseF = (baseF.*fs)./(2*pi); %convert from normalized freq to hz
end

baseP = mean(baseP,2);

power = zeros(length(freqs),length(targSignals));

for i = 1:length(targSignals);
    disp(i);
    oneTarg = targSignals{i}; oneTarg = oneTarg';
    
    if functionN == 1;            
        [targP,targF] = periodogram(oneTarg,[],freqs,fs);
    else
        [targP,targF] = pmtm(oneTarg,nw);
        targF = (targF.*fs)./(2*pi);
    end;
    
    targP = mean(targP,2);    
    normPower = targP./baseP;
    
    power(:,i) = normPower; %save power
    
end

frequency = targF;
    
    
    