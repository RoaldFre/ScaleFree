function plotCoopTrajectories(game, graph, nNodes, z)

filename = ["data_",game,"_",graph,"_",int2str(nNodes),"_",int2str(z)];
load(filename);

nParams = numel(params);

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
	legend(["param = ",num2str(params(p))], "location", "southeast");
	hold off;
end

