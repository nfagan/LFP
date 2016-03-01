%%

% selfBLA = concatenatedSignals;
% selfACC = concatenatedSignals;
% otherBLA = concatenatedSignals;
% otherACC = concatenatedSignals;
clearvars -except selfACC selfBLA otherBLA otherACC

%%
printFigure = 1; addLims = 1;

lims = [-.1 .13];
% lims = [-.4 -.2];
% lims = [0 .22]; 
% lims = [-.05 .12];
% lims = [-.38 -.18];
lims = [-.1 .2];
% lims = [-1.12 -.85];
% lims = [-1.12 -.88];

% trialN = trialN+1;
trialType = 'other';
trialN = 17;

%for SELF TARG: 1,2,7,12,39*,44*
%for OTHER TARG: 13,16*,
%for OTHER REWARD: 17,150*

switch trialType
    case 'self'; %SHOW THESE ARE DIFFERENT B/W AREAS
        signalBLA = selfBLA{1};
        signalACC = selfACC{1};
        toTitle = 'Self';
    case 'other'
        signalBLA = otherBLA{1};
        signalACC = otherACC{1};
        toTitle = 'Other';
end
        

time = -1000:1:2500;
oneTrialBLA = signalBLA(trialN,:);
oneTrialACC = signalACC(trialN,:);

% oneTrialBLA = signalBLA(35,:);
% oneTrialACC = signalACC(1,:);


%plot BLA first
figure;
h = subplot(2,1,1);
plot(time,oneTrialBLA)
title(strcat(toTitle,' BLA'));
ylabel('V');
if addLims
    ylim(lims);
end

%then plot ACC
subplot(2,1,2);
plot(time,oneTrialACC)
title(strcat(toTitle,' ACC')); ylabel('V');
xlabel('Time (ms from Target Onset)'); 
if addLims
    ylim(lims);
end

if printFigure
    cd /Users/Nick/Desktop
    print(toTitle,'-depsc')
end





