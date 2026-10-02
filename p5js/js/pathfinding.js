// Replaces the Pathfinder library: A* on the tile grid with the same costs and
// heuristic (AshCrowFlight(3), i.e. 3 x euclidean distance in pixels).
let graphCost = [];
let rNodes = [];
let startNode = null;
let endNode = null;

function makeGraph() {
  graphCost = levelMap.map((row, y) =>
    row.map((v, x) => (v === 2 ? null : (tiles[y][x].powerUp() ? 1 : 5)))
  );
}

function getNodeAt(x, y, maxDist) {
  const col = floor(x / largeurCase);
  const row = floor(y / largeurCase);
  if (!inGrid(col, row) || graphCost[row][col] === null) return null;
  const cx = col * largeurCase + largeurCase / 2;
  const cy = row * largeurCase + largeurCase / 2;
  if (dist(x, y, cx, cy) > maxDist) return null;
  return { col, row };
}

function usePathFinder() {
  if (startNode && endNode) rNodes = astar(startNode, endNode);
}

function astar(start, end) {
  const n = levelMap.length;
  const id = (c, r) => r * n + c;
  const h = (c, r) => 3 * dist(c, r, end.col, end.row) * largeurCase;

  const g = new Map([[id(start.col, start.row), 0]]);
  const parent = new Map();
  const closed = new Set();
  const open = [{ col: start.col, row: start.row, f: h(start.col, start.row) }];

  while (open.length > 0) {
    let best = 0;
    for (let k = 1; k < open.length; k++) if (open[k].f < open[best].f) best = k;
    const cur = open.splice(best, 1)[0];
    const curId = id(cur.col, cur.row);
    if (closed.has(curId)) continue;
    closed.add(curId);

    if (cur.col === end.col && cur.row === end.row) {
      const route = [];
      let key = curId;
      while (key !== undefined) {
        route.unshift({ col: key % n, row: floor(key / n) });
        key = parent.get(key);
      }
      return route;
    }

    for (const [dx, dy] of [[1, 0], [-1, 0], [0, 1], [0, -1]]) {
      const c = cur.col + dx;
      const r = cur.row + dy;
      if (!inGrid(c, r) || graphCost[r][c] === null) continue;
      const nId = id(c, r);
      if (closed.has(nId)) continue;
      const ng = g.get(curId) + graphCost[cur.row][cur.col];
      if (!g.has(nId) || ng < g.get(nId)) {
        g.set(nId, ng);
        parent.set(nId, curId);
        open.push({ col: c, row: r, f: ng + h(c, r) });
      }
    }
  }
  return [];
}
