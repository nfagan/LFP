function concatenatedAllSignals = concatenateAllBlocks(allSignals)
    
for i = 1:length(allSignals);
    extractedSignal = allSignals{i};
    
    if i < 2;
        storeOutcome = extractedSignal;
    else
        storeOutcome(end+1:(size(storeOutcome,1)+size(extractedSignal,1)),:) = extractedSignal;
    end;
    
end

concatenatedAllSignals = storeOutcome;
clear storeOutcome;

end
