module graph {
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
            w.write("<Node ",id,">");
        }

        //private
        proc addNeighbour(other : Node) {
            if (numNeighbours >= neighbours.numElements) then
                neighboursD = [1..2*numNeighbours];
            numNeighbours += 1;
            neighbours[numNeighbours] = other;
        }
    }

    class Graph {
        //private
        var numNodes = 0;
        var nodesD = [1..1];
        var nodes : [nodesD] Node;

        proc addNode(node : Node) {
            if (numNodes >= nodes.numElements) then
                nodesD = [1..2*numNodes];
            numNodes +=1;
            nodes[numNodes] = node;
        }
        proc writeThis(w : Writer) {
            w.write(nodes[1..numNodes]);
        }
    }

    /* Grow a scale-free network through growth and preferential attachment 
     * according to the Barabasi and Albert Model. */
    proc BAM(m0 : int, m : int, N : int) : Graph {
    }

    proc main() {
        var n1 = new Node(1);
        var n2 = new Node(2);
        var n3 = new Node(3);

        n1.edge(n2);
        n1.edge(n3);
        writeln(n1.neighbours);
        
        var g = new Graph();
        g.addNode(n1);
        g.addNode(n2);
        g.addNode(n3);
        writeln(g);
    }
}

// vim: ft=chpl sw=4 ts=4 expandtab smarttab
