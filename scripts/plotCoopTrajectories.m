% plotCoopTrajectories(game, graph, nNodes, z, parameters)
%
% Last argument is optional (default: use all parameters in the data set)
function processEverything(game, graph, nIteranions, nRuns, nNodes, z, parameters)

filename = ["data_",game,"_",graph,"_",int2str(nIteranions),"_",int2str(nRuns),"_",int2str(nNodes),"_",int2str(z)];
load(filename);

if (nargin < 6)
	error("Not enough arguments");
elseif (nargin < 7)
	parameters = params; %all parameters from the file
end

nParams = numel(parameters);

for i = 1:nParams
	[coop, errCoop] = processRuns(cooperativities(:,:,i));
	coops(i) = coop;
	errCoops(i) = errCoop;
end

coops = zeros(nParams, nRuns);
errCoops = zeros(nParams, nRuns);

for i = 1:nParams
	meanTrajectory(:,i) = mean(cooperativities(:,:,i)')'; %average trajectories of all runs
end


for p = 1:nParams
	figure;
	hold on;
	for r = 1:nRuns
		plot(cooperativities(:,r,p));
	end
	plot(meanTrajectory(:,p),"k");
	legend(["param = ",num2str(parameters(p))], "location", "southeast");
	hold off;
end

