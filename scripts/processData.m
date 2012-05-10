nParams = numel(params);

coops = zeros(nParams, 1);
errCoops = zeros(nParams, 1);

for i = 1:nParams
	[coop, errCoop] = processRuns(cooperativities(:,:,i));
	coops(i) = coop;
	errCoops(i) = errCoop;
end

errorbar(params, coops, errCoops);
