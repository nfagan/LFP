freq = 30;

times1 = 0:1/40000:.5;
d2 = ones(1,length(times1));
d2(1:2:end) = -1;

% d = 1.*rand(size(times1)).*rand(size(times1)).*d2;

% checkFreq = sin(2*pi*freq*times1) + d;

checkFreq = awgn(sin(2*pi*freq*times1),-10,'measured');

plot(checkFreq);