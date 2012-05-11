% plotCoopTrajectories(game, graph, nIteranions, nRuns, nNodes, z, parameters)
%
% Last argument is optional (default: use all parameters in the data set)
function plotCoopTrajectories(game, graph, nIteranions, nRuns, nNodes, z, parameters)

filename = ["data_",game,"_",graph,"_",int2str(nIteranions),"_",int2str(nRuns),"_",int2str(nNodes),"_",int2str(z)];
dir = "data";
load([dir,"/",filename]);

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
	h = plot(meanTrajectory(:,p),"k");
	set(h, "linewidth", 3);
	legend(["param = ",num2str(parameters(p))], "location", "southeast");
	hold off;


	plotfile = ["traj_",game,"_",graph,"_",int2str(nIteranions),"_",int2str(nRuns),"_",int2str(nNodes),"_",num2str(parameters(p)),".png"];
	axis([0,1,0,1], 'autox');
	print(["plots/",plotfile], "-dpng", "-r600", "-S3000,600");
end

