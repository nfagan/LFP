function [power,frequency] = doMultitaper(allSignalsForOneOutcome,takeMean)

    allSignalsForOneOutcome = allSignalsForOneOutcome'; %pmtm function treats columns as individual trials; flip input to reflect this
   
    fs = 1000;    
    numMultitapers = 5;    
    nw = (numMultitapers + 1)/2;
    
%     [pxx,f] = pmtm(allSignalsForOneOutcome,nw,size(allSignalsForOneOutcome,1),fs);
    
    %original
    [pxx,f] = pmtm(allSignalsForOneOutcome);
    
    %new
%     [pxx,f] = pmtm(allSignalsForOneOutcome,nw,size(allSignalsForOneOutcome,1));

    if takeMean
    
    meanPxx = mean(pxx,2);    
    pxx = meanPxx;
    
    end
    
    frequency = f;
    power = pxx;
    clear pxx;
    
end


