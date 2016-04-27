function normalized = signal_subtraction(real,reference)

if (size(real) == size(reference)) & (~iscell(real))
    real = {real}; % this function will expect cell arrays, where each cell
                   % is a time-window. If we're, for whatever reason,
                   % dealing with matrices (i.e., only one time-bin), make
                   % the input into a 1x1 cell array
    reference = {reference};
elseif (size(real) ~= size(reference))
    error(['The to-be-normalized and reference signals must be the same' ...
        , ' size (encompass the same number of time windows).']);
end

if size(real{1}) ~= size(reference{1})
    error(['There''s not an equal number of trials in the to-be-normalized' ...
        , ' vs. reference signals.']);
end

normalized = cell(1,length(real));
for i = 1:length(real);
    normalized{i} = real{i} - reference{i};
end
    