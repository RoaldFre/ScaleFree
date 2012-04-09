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
            //TODO locking does not work...
            var unlock$ : sync bool = false; /* lock */
            numNeighbours += 1;
            if (numNeighbours > neighbours.numElements) then
                neighboursD = [1..2*numNeighbours];
            neighbours[numNeighbours] = other;
            unlock$; /* unlock */
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
            //TODO locking does not work...
            var unlock$ : sync bool = false; /* lock */
            numNodes += 1;
            if (numNodes >= nodes.numElements) then
                nodesD = [1..2*numNodes];
            nodes[numNodes] = node;
            unlock$; /* unlock */
        }
        proc writeThis(w : Writer) {
            w.write("Graph N=",numNodes," {",nodes[1..numNodes],"}");
        }
    }

    /* Grow a scale-free network through growth and preferential attachment 
     * according to the Barabasi and Albert Model.
     * N must be larger than m */
    proc BAM(m0: int, m: int, N: int) : Graph {
        var nodes = [i in 1..N] new Node(i);
        var rstream = new RandomStream();
        for i in m..(N-1) {
            //TODO can connect multiple times!!
            var rands : [1..m] real;
            rstream.fillRandom(rands);
            var indices = 1 + floor(rands * i) : int;
            //[j in indices] nodes[i+1].edge(nodes[j]); //TODO locking doesn't work
            for j in indices do nodes[i+1].edge(nodes[j]);
        }
        writeln(nodes);
        return new Graph(nodes);
    }

    proc main() {
        var A : [1..10] real;
        var g = BAM(10,2,50);
        writeln(g);
    }
}

// vim: ft=chpl sw=4 ts=4 expandtab smarttab
