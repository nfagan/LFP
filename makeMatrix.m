function matrix = makeMatrix(cell)

for i = 1:length(cell)
    if i < 2;
        matrix = cell{i};
    else
        update = cell{i};
        matrix = vertcat(matrix,update);
    end
end
