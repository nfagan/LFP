function splitEventDataOutput = splitEventData(eventData)

toSplit = zeros(length(eventData),1);

for i = 1:length(eventData)-1;
    
    testForNeg = eventData(i+1,1) - eventData(i,1);
    
    if sign(testForNeg) == -1 && (eventData(i+1,1) ~= 0)
        toSplit(i) = 1;
    else
        toSplit(i) = 0;    
    end
end

findSplit = find(toSplit == 1);

if any(findSplit)
    k = 1;
    findSplit(end+1) = size(eventData,1);        
    splitEventDataOutput{k} = eventData(1:findSplit(k),:);
    splitEventDataOutput{k+1} = eventData(findSplit(k)+1:findSplit(k+1));    
else
    splitEventDataOutput{1} = eventData;
end
    

    