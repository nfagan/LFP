function normalizedSignal = normalizeByBaseline(ad,fixationOn,signalDuringWantedEpoch,norm)

amountToLookBack = norm.preFixWindow;
fixationOnAdjust = norm.adjFix;

if nargin < 5
    fixationOnAdjust = 0;
end
    
    fixationOn = fixationOn - fixationOnAdjust; %optionally look further 
                                                %backwards from fixation
    preFixationTime = fixationOn - amountToLookBack;
                                                
    meanBaselineSignal = mean(ad(preFixationTime:fixationOn));
    rawSignal = signalDuringWantedEpoch;
    normalizedSignal = rawSignal ./ meanBaselineSignal;
    
end