% Process the data of all the runs for a single game parameter.
%
% Params:
%   coopsOfRuns = [coopsOfRun1(t=0)   coopsOfRun2(t=0)  ... 
%                  coopsOfRun1(t=1)   coopsOfRun2(t=1)  ... 
%                  ...                ...               ... ]
%
%   x = The fraction at the end of the data set to use. Default: 0.1.
function [meanCoop, errCoop] = processRuns(coopsOfRuns, x)
	if (nargin < 1)
		error ("Need at least one argument!");
	end
	if (nargin < 2)
		x = 0.1;
		% Average the cooperativity for a fraction 'x' of the end 
		% of the data set, assumed to be in equilibruim.
	end

	nRuns = size(coopsOfRuns)(2);

	equilibrumCoops = coopsOfRuns(floor(x*end):end, :); %only the tail
	meanOfRuns = mean(equilibrumCoops); %mean for every run
	errOfRuns = std(equilibrumCoops); %error on mean for every run

	%simple mean (not weigted by errors or something fancy ...)
	meanCoop = mean(meanOfRuns); %single number: average of the cooperativity over all runs
	%Central limit theorem:
	errorDueToVariancesPerRun = norm(errOfRuns) / sqrt(nRuns); %error on meanCoop
	errorDueToVarianceOfMeansOfRuns = std(meanOfRuns);
	%TODO do error analysis thouroughly than just throwing these together!
	errCoop = sqrt(errorDueToVariancesPerRun^2 + errorDueToVarianceOfMeansOfRuns^2);
end

