function plotData(filename)

data = load(filename);

params = data(1, :);
cooperativities = data(2:end, :);

plot(cooperativities);

