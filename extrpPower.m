function power2 = extrpPower(power,frequency,thresh)

freqCheck = frequency{1};
rows = 1:length(freqCheck);
z = rows(freqCheck == thresh);

for i = 1:length(power);
    
    if size(power{i},2) > size(power{i},1);
        power{i} = power{i}';
    end
    
    power2{i}  = interp1(frequency{i}(z:end),power{i}(z:end),(1:z-1),'linear','extrap');
    power2{i} = [power2{i}';power{i}(z+1:end)];
end
