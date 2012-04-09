module graph {
    class Node {
        var id : int;

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

        //'private'
        proc addNeighbour(other : Node) {
            if (numNeighbours >= neighbours.numElements) then
                neighboursD = [1..2*numNeighbours];
            numNeighbours += 1;
            neighbours[numNeighbours] = other;
        }
    }

    proc main() {
        var n1 = new Node(1);
        var n2 = new Node(2);
        var n3 = new Node(3);

        n1.edge(n2);
        n1.edge(n3);
        writeln(n1.neighbours);
    }
}

// vim: ft=chpl sw=4 ts=4 expandtab smarttab
