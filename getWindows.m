function outputSignals = getWindows(inputSignals,stepSize,windowSize)

if iscell(inputSignals)
    inputSignals = inputSignals{1};
end

multiplier = 40e3/1e3; %because signals are sampled at 40,000 hz
stepSize = stepSize*multiplier;
windowSize = windowSize*multiplier;
toTruncate = windowSize/stepSize;

stps = 1:stepSize:size(inputSignals,2);

if stps(end) ~= size(inputSignals,2); %always have last element be equal to length of inputSignal
    stps(end+1) = size(inputSignals,2);
end

outputSignals = cell(1,length(stps)-toTruncate);%preallocate

for i = 1:length(stps)-toTruncate;
    outputSignals{i} = inputSignals(:,stps(i):stps(i)+windowSize);
end;







