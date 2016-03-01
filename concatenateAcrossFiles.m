function concatenatedSignals = concatenateAcrossFiles(allSignals)

for k = 1:size(allSignals,2)
    for i = 1:size(allSignals,1);
        if i < 2;
            storeSignals = allSignals{i,k};
        else
            storeSignals = vertcat(storeSignals,allSignals{i,k});
        end
    end
    
    concatenatedSignals{k} = storeSignals;
    clear storeSignals    
end

    

