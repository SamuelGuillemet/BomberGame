void makeGraph(Graph g) {
    int tilesX = map.length, tilesY = map.length;
    int delta = tilesX + 1;
    GraphNode aNode;
    
    PVector pos = new PVector(largeurCase / 2, largeurCase / 2);
    
    int nodeID;
    int cost;
    
    for (int y = 0; y < map.length; y++) {
        nodeID = delta * y + delta;
        pos.x = largeurCase / 2;
        for (int x = 0; x < map.length; x++) {
            
            if (map[y][x] != 2) {
                aNode = new GraphNode(nodeID, pos.x, pos.y);
                g.addNode(aNode);
                if (tiles[y][x].dirt == true) cost = 10;
                if (tiles[y][x].powerUp()) cost = 1;
                else cost = 5;
                if (x > 0) g.addEdge(nodeID, nodeID - 1, cost);
                if (x < tilesX - 1) g.addEdge(nodeID, nodeID + 1, cost);
                if (y > 0) g.addEdge(nodeID, nodeID - delta, cost);
                if (y < tilesY - 1) g.addEdge(nodeID, nodeID + delta, cost);
            }
            pos.x += largeurCase;
            nodeID++;
        }
        pos.y += largeurCase;
    }
}

void usePathFinder(IGraphSearch pf) {
    if (startNode!= null && endNode != null) {
        pf.search(startNode.id(), endNode.id(), true);
    }
    rNodes = pf.getRoute();
    exploredEdges = pf.getExaminedEdges();
}

IGraphSearch makePathFinder(Graph graph) {
    IGraphSearch pf = null;
    pf = new GraphSearch_Astar(graph, new AshCrowFlight(3));
    return pf;
}

void drawEdges(GraphEdge[] edges, int lineCol, float sWeight) {
    if (edges != null) {
        push();
        colorMode(RGB);
        noFill();
        stroke(lineCol);
        strokeWeight(sWeight);
        for (GraphEdge ge : edges) {
            line(ge.from().xf(),ge.from().yf(), ge.to().xf(), ge.to().yf());
        }
    }
    pop();
}

void drawNodes() {
    push();
    colorMode(RGB);
    noStroke();
    fill(255, 0, 255, 72);
    for (GraphNode node : gNodes)
        ellipse(node.xf(), node.yf(), 15, 15);
    pop();
}

void drawRoute(GraphNode[] r, int lineCol, float sWeight) {
    if (r.length >= 2) {
        push();
        colorMode(RGB);
        stroke(lineCol);
        strokeWeight(sWeight);
        noFill();
        for (int i = 1; i < r.length; i++)
            line(r[i - 1].xf(), r[i - 1].yf(), r[i].xf(), r[i].yf());
        pop();
    }
}
