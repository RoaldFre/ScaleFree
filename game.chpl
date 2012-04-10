/* Evolutionary game theory on scale free networks */
module game {
    use Random;
    use util;

    enum Move {cooperate, defect}

    class Node {
        //needs to be unique for every node
        const id: int;

        var payoff = 0.0;
        var myMove: Move;

        //private
        var numNeighbours = 0;
        var neighboursD = [1..1];
        var neighbours : [neighboursD] Node;

        proc Node(id) {
            this.id = id;
        }
        proc Node(id, move) {
            this.id = id;
            this.myMove = move;
        }
        proc Node(id, probOfCooperating, rstream) {
            this.id = id;
            seedStrategy(probOfCooperating, rstream);
        }

        proc move() return myMove;

        proc getNeighbours() return neighbours[1..numNeighbours];

        /* Link this node with the given node by creating an edge between 
         * them. */
        proc edge(other: Node) {
            this.addNeighbour(other);
            other.addNeighbour(this);
        }

        proc seedStrategy(probOfCooperating, rstream) {
            myMove = if rstream.getNext() < probOfCooperating then
                    Move.cooperate else Move.defect;
        }

        proc writeThis(w : Writer) {
            w.write("<Node ",id," {",payoff,"} [",neighbours[1..numNeighbours].id,"]>");
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

        proc getNodes() return nodes[1..numNodes];

        proc seedStrategies(probOfCooperating) {
            var rstream = new RandomStream();
            [n in getNodes()] n.seedStrategy(probOfCooperating, rstream);
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

    class Game {
        const graph: Graph;
        const payoffsD: domain((/* your */Move, /* opponents's */Move));
        var payoffs: [payoffsD] real;

        /*
         * These are the payoff you get when:
         *
         *               | other cooperates |   other defects
         * --------------+------------------+-------------------
         * you cooperate |  R (mutual coop) |  T (exploited)
         * you defect    |  S (exploiting)  |  P (mutual defect)
         */
        proc Game(T, R, S, P, graph) {
            initPayoffsD();
            this.graph = graph;
            payoffs[(Move.cooperate, Move.cooperate)] = R;
            payoffs[(Move.cooperate, Move.defect   )] = T;
            payoffs[(Move.defect,    Move.cooperate)] = S;
            payoffs[(Move.defect,    Move.defect   )] = P;
        }

        /* Play a single round of the game, sets the payoff. */
        proc play() {
            [node in graph.getNodes()] node.payoff = 0;
            for node in graph.getNodes() do
                for neigh in node.getNeighbours() do
                    if node.id < neigh.id then /* avoid double playing */
                        play(node, neigh);
        }

        //private
        proc play(a, b) {
            var aMov = a.move();
            var bMov = b.move();
            a.payoff += payoffs[(aMov, bMov)];
            b.payoff += payoffs[(bMov, aMov)];
        }

        //TODO Find better way so I don't have to do this manually!
        proc initPayoffsD() {
            payoffsD += (Move.cooperate, Move.cooperate);
            payoffsD += (Move.cooperate, Move.defect   );
            payoffsD += (Move.defect,    Move.cooperate);
            payoffsD += (Move.defect,    Move.defect   );
        }
    }

    /* Prisoners Dilemma.
     * Rescaled the game scores and reduced to a single parameter */
    proc PD(b, graph) return new Game(b, 1, 0, 0, graph);

    /* Snowdrift Game.
     * Rescaled the game scores and reduced to a single parameter */
    proc SG(r, graph) {
        var beta = ((1/r) + 1) / 2;
        return new Game(beta, beta - 1/2, beta - 1, 0, graph);
    }

    proc main() {
        var g = BAM(2,2,50);
        g.seedStrategies(0.5);
        var pd = PD(1.5, g);
        pd.play();
        writeln(g);
    }
}

// vim: ft=chpl sw=4 ts=4 expandtab smarttab
