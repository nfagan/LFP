function outputCoherence = doNormalizedCoherence(coherence,basecoherence)

outputCoherence = zeros(size(coherence,1),size(coherence,2));

for j = 1:size(coherence,2);
    oneCol = coherence(:,j);
    oneCol = oneCol - basecoherence;
    
    outputCoherence(:,j) = oneCol;
    
end


