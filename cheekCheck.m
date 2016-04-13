startDir = '/Volumes/My Passport/NICK/Chang Lab 2016/LFP/cheek_electrode_data';
cd(startDir);
d = dir('*.pl2');

fileN = 2;

cheek = getPlexonData(d(fileN),'WB11');
AM = getPlexonData(d(fileN),'WB09');

%%

cheek_ad = cheek.ad;
am_ad = AM.ad;

cheek_ad = {cheek_ad'};
am_ad = {am_ad'};

%%

[power,frequency] = doPowerSpectrum(cheek_ad,'p',0,[0:.5:50]);
[amPower,amFrequency] = doPowerSpectrum(am_ad,'p',0,[0:.5:50]);

% binnedCheek = getWindows(cheek',50,250);
% binnedAM = getWindows(AM',50,250);

%%
plot(frequency{1},power{1});
xlim([0 10]);
ylim([0 100]);

figure
plot(amFrequency{1},amPower{1});

xlim([0 10]);
ylim([0 100]);