%%

% blaSignals = targetAcSignals{1};
% accSignals = targetAcSignals{1};

trialType = 'other';

if strcmp(trialType,'other');
    load('/Volumes/My Passport/NICK/Chang Lab 2016/LFP/voltage_data/other_one_day.mat');
else
    load('/Volumes/My Passport/NICK/Chang Lab 2016/LFP/voltage_data/self_one_day.mat');
end

%%

%%%possible trials:
%           other: 1;
%           

doPrint = 0;

lims = [];

trialN = 10;

% for i = 1:size(blaSignals,1);

% trialN = trialN +1;

windowSize = 250;
windowSize = windowSize*40;

% blaSignals = blaSignals{1};
% accSignals = accSignals{1};

BLAoneTrialSignals = blaSignals(trialN,1:size(blaSignals,2)-windowSize);
ACConeTrialSignals = accSignals(trialN,1:size(accSignals,2)-windowSize);


plotTime = -1000:1/40:2000;

figure
subplot(2,1,1);
plot(plotTime,BLAoneTrialSignals);
title('BLA Voltage Over Time');
xlabel('Time from Target Acquired (ms)');
ylabel('µV');

if ~isempty(lims);
    ylim(lims);
end;

subplot(2,1,2);
plot(plotTime,ACConeTrialSignals);

title('ACC Voltage Over Time');
xlabel('Time from Target Acquired (ms)');
ylabel('µV');
if ~isempty(lims);
    ylim(lims);
end;

name = num2str(i);

if doPrint

    print(name,'-depsc');
    close all;

end

clearvars -except blaSignals accSignals trialN lims

% end

