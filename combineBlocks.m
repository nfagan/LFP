function allBlocksByOutcome = combineBlocks(separateByOutcomePerBlock)

for k = 1:length(separateByOutcomePerBlock) % for each block ...
    extractedBlock = separateByOutcomePerBlock{k}; %extract the current block
    
    
    if k < 2 % if this is the first outcome, storeOutcome is simply event times of the first block
        
        storeOutcome = extractedBlock;
    else %otherwise, append to the first block (or second, third, ...) the event times of the current block
        
    storeOutcome(end+1:(size(extractedBlock,1)+size(storeOutcome,1)),:) = extractedBlock;
    
    end;

    
clear extractedBlock extractedBlock   
end

allBlocksByOutcome = storeOutcome;

end

    