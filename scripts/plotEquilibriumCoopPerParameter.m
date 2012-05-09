function plotEquilibriumCoopPerParameter(filename, color)

if nargin < 2
	color = "b"
end

data = load(filename);

params = data(1, :);
cooperativities = data(2:end, :);


%average cooperativity for a fraction 'x' of the end of the data set
x = 0.3;

equilibriumData = cooperativities(floor(x*end):end, :);
equilibriumCoop = mean(equilibriumData);
err = std(equilibriumData);
errorbar(params, equilibriumCoop, err, color);
axis([0,1,0,1]);
