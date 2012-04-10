module util {
    /* Fill X with random integers between lo and hi (inclusive). Note that 
     * if X.numElements > hi-lo, you are screwed (infinite loop).
     * Sidenote/TODO: if |X| almost equal to hi-lo, propably faster to do a 
     * permutation shuffle of lo..hi and then a slice. */
    proc fillDistinctRandomInts(out X: [], lo:int, hi:int, rstream) {
        const N = X.numElements;
        //TODO we build our own array, because we can't assume that X is 0 
        //or 1 indexed, nor that it is integer indexed even! -- better way? 
        //eg filling X with nil first, and then looping over it to check 
        //for doubles?
        var nums: [1..N] int; 
        var i = 0;
        while (i < N) {
            var newNum = lo + floor(rstream.getNext() * (hi - lo + 1)) : int;
            if contains(nums[1..i], newNum) then continue; /* other number */
            i += 1;
            nums[i] = newNum;
        }
        [(x,n) in (X,nums)] x = n;
    }

    proc contains(X, elem) {
        for x in X do //can't return from forall, so doing it serially
            if x == elem then return true;
        return false;
    }
}
