function addTickLabels(numWindows,stepSize)
    initial = 0;    
    for i = 1:numWindows
        if i > 1;
            initial = initial + stepSize;
        end
        
        tickLabel{i} = num2str(initial);
    end
        
    ax.XTickLabel = tickLabel;