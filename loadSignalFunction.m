function signals = loadSignalFunction(dataType,trialInfo,windowInfo)

signals = masterGetSignals3(dataType,trialInfo,windowInfo);

% signals = fastica(signals{1});

signals = getWindows(signals,windowInfo.stepSize,windowInfo.windowSize);


fprintf('\n \n Saving...');
cd('/Volumes/My Passport/NICK/Chang Lab 2016/LFP/Spectrogram_data/target_acquire');
fprintf('\n \t Done');