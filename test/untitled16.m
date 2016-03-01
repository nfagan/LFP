d = getWindows(test2,5,10); %step size, windowSize

for i = 1:length(d);
    oneD = d{i};    
    for j = 1:size(oneD,1);
        oneRow = oneD(j,:);
        sumOneRow(j) = sum(oneRow);        
    end
    sumD = mean(sumOneRow);
    
    oneSps = sumD/length(oneD);    
    sps(:,i) = oneSps;
    
end

sps = sps*40000;
sps2 = smooth(sps,20);
plot(sps2);



    
    