test2 = test{1};
% test2 = concatenatedSignals{1};
hold on;

xs = 1:size(test2,2);
ys = 1:size(test2,1);

for j = 1:length(xs);
    oneCol = test2(:,j);
    for i = 1:length(ys);
        if oneCol(i) == 1;
            plot(xs(j),ys(i),'*');
        end
    end
end
% 
% for i = 1:size(test2,1);
%     d(i) = sum(test2(i,:));
% end

xlim([0 size(test2,2)]);