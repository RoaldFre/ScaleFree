% function processEverything(game, graph, nIteranions, nRuns, nNodes, zs)
%
% Processes data for various z values of the network (z = average degree of 
% the nodes)
% This assumes that the data sets for various z were created with the same 
% settings.
function processEverything(game, graph, nIteranions, nRuns, nNodes, zs)

if (nargin < 6)
	error("Not enough arguments");
end

basename = ["data_",game,"_",graph,"_",int2str(nIteranions),"_",int2str(nRuns),"_",int2str(nNodes)];
dir = "data";

clf;
hold all;
for z = zs
	load([dir,"/",basename,"_",int2str(z)]);
	processData;
end

nZs = numel(zs);
for i = 1:nZs
	legendEntries{i} = ["z = ",int2str(zs(i))];
end
legend(legendEntries);
axis([min(params), max(params), 0, 1], 'autoy');
hold off;


plotfile = [game,"_",graph,"_",int2str(nIteranions),"_",int2str(nRuns),"_",int2str(nNodes),".png"];
print(["plots/",plotfile], "-dpng", "-r600", "-S1800,1500","-tight");
