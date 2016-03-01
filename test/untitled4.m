% hold on;

% for i = 1:length(test);
%     
%     oneTest = test{i};
%     oneTest = mean(oneTest);
%     oneTest = mean(oneTest);
%     
%     outputTest(:,i) = oneTest;
% end

hold on;
toAdd = 0;
for i = 1:size(test2,1);
    
    oneRow = test2(i,:);
    
    for j = 1:length(oneRow);
        if oneRow(j) == 1;
            plot(j,(oneRow(j)+i),'*');
            
        end
    end
end

            
