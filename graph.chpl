module graph {
    use Random;

    class Node {
        //needs to be unique for every node
        const id : int;

        //private
        var numNeighbours = 0;
        var neighboursD = [1..1];
        var neighbours : [neighboursD] Node;

        /* Link this node with the given node by creating an edge between 
         * them. */
        proc edge(other : Node) {
            this.addNeighbour(other);
            other.addNeighbour(this);
        }
        proc writeThis(w : Writer) {
            w.write("<Node ",id," [",neighbours[1..numNeighbours].id,"]>");
        }

        //private
        proc addNeighbour(other : Node) {
            //atomic { //NOT IMPLEMENTED YET!!
                numNeighbours += 1;
                if (numNeighbours > neighbours.numElements) then
                    neighboursD = [1..2*numNeighbours];
                neighbours[numNeighbours] = other;
            //}
            /* Note: this still gives potential problems if thread1 reads 
             * an old numNeighbours first, then a neighbour gets added by 
             * thread2 and then thread1 does something with the neighbours 
             * (ie it doesn't know that there is an extra one...) Problem?
             *
             * Either way, atomic isn't implemented yet in chpl... */
        }
    }

    class Graph {
        proc Graph() {}

        /* All given nodes must be non-nil */
        proc Graph(theNodes) {
            nodesD = [1..theNodes.numElements];
            for n in theNodes do addNode(n);
        }

        //private
        var numNodes = 0;
        var nodesD = [1..1];
        var nodes : [nodesD] Node;

        proc addNode(node : Node) {
            //atomic { //NOT IMPLEMENTED YET!!
                numNodes += 1;
                if (numNodes >= nodes.numElements) then
                    nodesD = [1..2*numNodes];
                nodes[numNodes] = node;
            //}
        }
        proc writeThis(w : Writer) {
            w.write("Graph N=",numNodes," {",nodes[1..numNodes],"}");
        }
    }

    /* Grow a scale-free network through growth and preferential attachment 
     * according to the Barabasi and Albert Model.
     * start with m0 nodes
     * add nodes and connect them to m previous random nodes
     * N must be larger than m, m0 must be larger or equal to m */
    proc BAM(m0: int, m: int, N: int) : Graph {
        var nodes = [i in 1..N] new Node(i);
        var rstream = new RandomStream();
        var randIndices : [1..m] int;
        for i in (m0+1)..N {
            fillDistinctRandomInts(randIndices, 1, i-1, rstream);
            for j in randIndices do nodes[i].edge(nodes[j]);
        }
        return new Graph(nodes);
    }

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

    proc main() {
        var g = BAM(2,2,50);
        writeln(g);
    }
}

// vim: ft=chpl sw=4 ts=4 expandtab smarttab
