module util {
    /* Fill X with random indices between 1 and weights.numElements.
     * (inclusive).
     * If all weights are zero, indices are chosen uniformly.
     * Note that if X.numElements > weights.numElements, you are screwed 
     * (infinite loop). */
    proc fillWeightedIndices(out X: [], weights: [], rstream) {
        var nIndices = X.numElements;
        var nWeights = weights.numElements;
        assert(nIndices <= nWeights);

        var totWeight = + reduce weights;
        if (totWeight <= 0) {
            fillDistinctRandomInts(X, 1, nWeights, rstream);
            return;
        }

        //var cumulativeProbs = + scan ([w in weights] w/totWeight);
        var cumulativeProbs = + scan (weights/totWeight:real);
        //TODO we build our own array, because we can't assume that X is 0 
        //or 1 indexed, nor that it is integer indexed even! -- better way? 
        //eg filling X with nil first, and then looping over it to check 
        //for doubles?
        var indices: [1..nIndices] int; 
        var i = 1;
        while (i <= nIndices) {
            var rand = rstream.getNext();
            var theIndex = -1;
            for anIndex in 1..nWeights {
                if rand < cumulativeProbs[anIndex] {
                    theIndex = anIndex;
                    break;
                }
            }
            assert(theIndex > 0);
            if contains(indices[1..i], theIndex) then continue; /* try again */
            indices[i] = theIndex;
            i += 1;
        }
        [(x,n) in (X,indices)] x = n;
    }

    /* Fill X with random integers between lo and hi (inclusive). Note that 
     * if X.numElements > hi-lo, you are screwed (infinite loop).
     * Sidenote/TODO: if |X| almost equal to hi-lo, propably faster to do a 
     * permutation shuffle of lo..hi and then a slice. */
    proc fillDistinctRandomInts(out X: [], lo:int, hi:int, rstream) {
        const N = X.numElements;
        assert(N > hi - lo);

        //TODO we build our own array, because we can't assume that X is 0 
        //or 1 indexed, nor that it is integer indexed even! -- better way? 
        //eg filling X with nil first, and then looping over it to check 
        //for doubles?
        var nums: [1..N] int; 
        var i = 0;
        while (i < N) {
            var newNum = randomInt(lo, hi, rstream);
            if contains(nums[1..i], newNum) then continue; /* other number */
            i += 1;
            nums[i] = newNum;
        }
        [(x,n) in (X,nums)] x = n;
    }

    proc fillRandomInts(out X: [], lo:int, hi:int, rstream) {
        [x in X] x = randomInt(lo, hi, rstream);
    }

    proc randomInt(lo, hi, rstream): int {
        return lo + floor(rstream.getNext() * (hi - lo + 1)) : int;
    }

    proc contains(X, elem) {
        for x in X do //can't return from forall, so doing it serially
            if x == elem then return true;
        return false;
    }
}
