test2 = concatenatedSignals{1};
hold on;
for i = 1:size(test2,2);
    oneRow = test2(i,:);
    ys(1:length(oneRow)) = i;
    for j = 1:length(oneRow);    
        if oneRow(j) == 1;
            plot(oneRow(j),ys(i),'*');
        end
    end
%     plot(oneRow,ys);
end;