function doPsth(signals,stepSize,windowSize,initial,lengthToPlot)

endPoint = lengthToPlot + initial-windowSize;

d = getWindows(signals,stepSize,windowSize); %step size, windowSize

for i = 1:length(d);
    oneD = d{i};
    
    sums = sum(oneD,2);
    sumD = mean(sums);
    
    oneSps = sumD/length(oneD);    
    sps(:,i) = oneSps;
    
end

sps = sps*40000;
sps2 = smooth(sps,20);
plot(sps2);

hold on;

times = initial:stepSize:endPoint;
zeroInd = find(times == 0); zeroInd(2) = zeroInd;
yMax = [0 round(max(sps2)) + 1];
plot(zeroInd,yMax,'k');

ys = 1+max(yMax):max(yMax)+size(sums,1);

for i = 1:length(d);
    oneD = d{i};
    sums = sum(oneD,2);    
    
    for j = 1:length(sums);
        if sums(j) == 1;
            plot(i,ys(j),'k*');
        end
    end
end

    
    
    
    




