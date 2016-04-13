plexfile.name = '/Volumes/My Passport/NICK/Chang Lab 2016/LFP/cheek_electrode_data/Olga to Nick/mouth_elec_day_2/442016_KurosawaCoppola_extra electrode to the mouth.pl2';
cheek = getPlexonData(plexfile,'WB11');

am = getPlexonData(plexfile,'WB09');

%%

pl2 = PL2ReadFileIndex(plexfile.name);

%%
signals{1} = cheek.ad';
signals = {signals{1}(1:(250*10000+1))};
amSignals{1} = am.ad';
amSignals = {amSignals{1}(1:(250*10000+1))};

% [power,frequency] = doPowerSpectrum(signals,'p',0,[0:.5:50]);
% windowsSignals = getWindows(signals{1},250,250);
amWindow = getWindows(signals{1},250,250);

%%

plot(frequency{10},power{20});
xlim([0 10]);

%%

d = {signals{1}(1:(250*10000+1))};
windowSignals = getWindows(d,250,250);

%%

% [power,frequency] = doPowerSpectrum(windowSignals,'p',0,[0:.5:50]);
[newPower,newFreq] = doPowerSpectrum(amWindow,'p',0,[0:.5:50]);
[newPower2] = extrpPower(newPower,newFreq,5);


%%

for i = 1:length(power);
    power{i} = power{i}';
    frequency{i} = frequency{i}';
end

%% extrapolate

for i = 1:length(power);
%     power2{i} = fnxtr(power{i},1);
    power2{i}  = interp1(frequency{i}(10:end),power{i}(10:end),(1:9),'linear','extrap');
    power2{i} = [power2{i}';power{i}(11:end)];
%     power2{i} = power2{i}
end
    

%%

h = spectrogramOverTime4(power2,frequency,8,1,0,250,[-1000 1000],[0 70]);