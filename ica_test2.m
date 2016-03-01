%% ica
signals = targetAcSignals{1};

icasig = fastica(signals);

%% autocorrelation to detect lowest component

for j = 1:size(icasig,1);
    acf(j,:) = autocorr(icasig(j,:),1);
end
% acf = autocorr(icasig,1)

acfVal = acf(:,2); 
[~,minInd] = min(acfVal);
[~,maxInd] = max(acfVal);

plot(icasig(maxInd,:));



%%

signals = plex.ad;

signals = downsample(signals,40);
signals2(end:3799040) = 0;

% signals2 = wextend('1','zpd',signals,3);

SWC = swt(signals2,10,'haar');

%%%
N = length(signals2);
numer = median(abs(SWC),2);
denom = .6745;

a = numer./denom;
T = a.*sqrt(log(N));