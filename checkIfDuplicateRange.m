function trueFalse = checkIfDuplicateRange(picTime,oneTrialTime)

    splitPicTime = splitEventData(picTime);
    for j = 1:length(splitPicTime)
        minMax(1,j) = min(splitPicTime{j});
        minMax(2,j) = max(splitPicTime{j});
    end
    
    for j = 1:size(minMax,2);
        if (oneTrialTime > minMax(1,j)) && (oneTrialTime < minMax(2,j))
            checkWithinRange(j) = 1;
        else
            checkWithinRange(j) = 0;
        end
    end
    
    if sum(checkWithinRange) > 1;
        trueFalse = 1;
    else
        trueFalse = 0;
    end
    
    
    

