function outputPower = changePower(power)

x = round(rand*(length(power)));
power(x:end) = power(x:end)+1000;

outputPower = power;




