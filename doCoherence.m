function [coherence,freq] = doCoherence(blaSignals,accSignals,maxFreq,takeMean)

if length(blaSignals) ~= length(accSignals);
    disp('warning: lengths not equivalent');
    return
end

fs = 40000;

for i = 1:length(blaSignals);
    
    oneBla = blaSignals{i};
    oneAcc = accSignals{i};
    
    oneBla = oneBla';
    oneAcc = oneAcc';
        
    params.tapers = [11 5];
    params.pad = -1;
    params.Fs = fs;
    
    if ~isempty(maxFreq);
        params.fpass = [0 maxFreq];
        freqs = 0:2:maxFreq;
    end;
    
    [C,f] = mscohere(oneBla,oneAcc,[],[],freqs,fs);
    
%     [C,phi,S12,S1,S2,f]=coherencyc(oneBla,oneAcc,params);    
%     clear phi S12 S1 S2;   
%     
    w = f';
    
%     %original
%     [Cxy,w] = mscohere(oneBla,oneAcc);
%     w = (w.*fs)./(2*pi); %convert from normalized freq to hz    
%     Cxy = mean(Cxy,2);
    
    if takeMean
        Cxy = mean(C,2); 
        coherence(:,i) = Cxy;
        freq(:,i) = w;
    else
        coherence{i} = C;
        freq(:,i) = w;
    end
end
    
    

