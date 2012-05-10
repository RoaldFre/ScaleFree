% Processes data for various z values of the network (z = average degree of 
% the nodes)
function processEverything(game, graph, nNodes, zs)

basename = ["data_",game,"_",graph,"_",int2str(nNodes)];

clf;
hold all;
for z = zs
	load([basename,"_",int2str(z)]);
	processData;
end

nZs = numel(zs);
for i = 1:nZs
	legendEntries{i} = ["z = ",int2str(zs(i))];
end
legend(legendEntries);
hold off;
