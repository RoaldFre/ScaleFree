module gameTest {

    use game;

    proc gameTest() {
        var R = 1.234;
        var S = 2.341;
        var P = 3.412;
        var T = 4.123;
        var n1 = new Node(1);
        var n2 = new Node(2);
        n1.edge(n2);
        var nodes: [1..2] Node = (n1, n2);
        var graph = new Graph(nodes);
        var game = new Game(R, S, T, P, 9.876, graph);

        n1.myMove = Move.cooperate;
        n2.myMove = Move.cooperate;
        game.play();
        assert(n1.payoff == R);
        assert(n2.payoff == R);

        n1.myMove = Move.cooperate;
        n2.myMove = Move.defect;
        game.play();
        assert(n1.payoff == S);
        assert(n2.payoff == T);

        n1.myMove = Move.defect;
        n2.myMove = Move.cooperate;
        game.play();
        assert(n1.payoff == T);
        assert(n2.payoff == S);

        n1.myMove = Move.defect;
        n2.myMove = Move.defect;
        game.play();
        assert(n1.payoff == P);
        assert(n2.payoff == P);
    }

    proc PDtest() {
        var b = 1.234;
        var n1 = new Node(1);
        var n2 = new Node(2);
        n1.edge(n2);
        var nodes: [1..2] Node = (n1, n2);
        var graph = new Graph(nodes);
        var game = PD(b, graph);

        n1.myMove = Move.cooperate;
        n2.myMove = Move.cooperate;
        game.play();
        assert(n1.payoff == 1);
        assert(n2.payoff == 1);

        n1.myMove = Move.cooperate;
        n2.myMove = Move.defect;
        game.play();
        assert(n1.payoff == 0);
        assert(n2.payoff == b);

        n1.myMove = Move.defect;
        n2.myMove = Move.cooperate;
        game.play();
        assert(n1.payoff == b);
        assert(n2.payoff == 0);

        n1.myMove = Move.defect;
        n2.myMove = Move.defect;
        game.play();
        assert(n1.payoff == 0);
        assert(n2.payoff == 0);
    }

    proc SGtest() {
        var r = 0.1234;
        var n1 = new Node(1);
        var n2 = new Node(2);
        n1.edge(n2);
        var nodes: [1..2] Node = (n1, n2);
        var graph = new Graph(nodes);
        var game = SG(r, graph);

        var beta = (1 + r) / (2 * r);

        n1.myMove = Move.cooperate;
        n2.myMove = Move.cooperate;
        game.play();
        assert(n1.payoff == beta - 0.5);
        assert(n2.payoff == beta - 0.5);

        n1.myMove = Move.cooperate;
        n2.myMove = Move.defect;
        game.play();
        assert(n1.payoff == beta - 1);
        assert(n2.payoff == beta);

        n1.myMove = Move.defect;
        n2.myMove = Move.cooperate;
        game.play();
        assert(n1.payoff == beta);
        assert(n2.payoff == beta - 1);

        n1.myMove = Move.defect;
        n2.myMove = Move.defect;
        game.play();
        assert(n1.payoff == 0);
        assert(n2.payoff == 0);
    }



    proc main() {
        PDtest();
        SGtest();
        gameTest();
    }
}
