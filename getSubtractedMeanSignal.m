function outputSignals = getSubtractedMeanSignal(allSignals,targetSignals)

for i = 1:length(allSignals);    
       
    oneAll = allSignals{i};
    oneTarg = targetSignals{i};    
    oneAll = mean(oneAll);
    subtractedTarg = zeros(size(oneTarg,1),size(oneTarg,2));
    for j = 1:size(oneTarg,1);
        subtractedTarg(j,:) = oneTarg(j,:) - oneAll;
    end;
    
outputSignals{i} = subtractedTarg;
end;


   