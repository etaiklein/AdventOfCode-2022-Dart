import '../utils/index.dart';
import 'dart:collection';
import 'dart:math' as math;

/* modified from https://github.com/sethladd/dart-a-star/blob/b912b4cc7e1408ed747995b9f0dcc58d2737695d/benchmark/benchmark_2d.dart */
class Maze {
  List<List<Tile>> tiles;
  Tile start;
  Tile goal;

  Maze(this.tiles, this.start, this.goal);

  factory Maze.parse(String map) {
    final tiles = <List<Tile>>[];
    final rows = map.trim().split('\n');
    Tile? start;
    Tile? goal;

    for (var rowNum = 0; rowNum < rows.length; rowNum++) {
      final row = <Tile>[];
      final lineTiles = rows[rowNum].trim().split('');

      for (var colNum = 0; colNum < lineTiles.length; colNum++) {
        final t = lineTiles[colNum];
        final height = getHeight(t);
        final tile = Tile(colNum, rowNum, height);
        if (t == 'S') {
          start = tile;
        }
        if (t == 'E') {
          goal = tile;
        }
        row.add(tile);
      }

      tiles.add(row);
    }

    return Maze(tiles, start!, goal!);
  }
}

int getHeight(String character) {
  if (character == character.toLowerCase()) {
    return character.codeUnitAt(0) - "a".codeUnitAt(0);
  } else if (character == "S") {
    return 0;
  } else {
    return "z".codeUnitAt(0) - "a".codeUnitAt(0) + 1;
  }
}

class Tile {
  final int x, y, height;
  final int _hashcode;
  final String _str;

  bool obstacle;

  // for A*
  double _f = -1; // heuristic + cost
  double _g = -1; // cost
  double _h = -1; // heuristic estimate
  int _parentIndex = -1;

  Tile(this.x, this.y, this.height, {this.obstacle = false})
      : _hashcode = '$x,$y'.hashCode,
        _str = '[X:$x, Y:$y, height:$height, obs:$obstacle]';

  @override
  String toString() => _str;

  @override
  int get hashCode => _hashcode;

  @override
  bool operator ==(Object other) => other is Tile && x == other.x && y == other.y;
}

double heuristic(Tile tile, Tile goal) {
  final x = tile.x - goal.x;
  final y = tile.y - goal.y;
  return math.sqrt(x * x + y * y);
}

/// This algorithm works only for 2D grids. There is a lot of room to optimize
/// this further.
Queue<Tile> aStar2D(Maze maze) {
  final map = maze.tiles;
  final start = maze.start;
  final goal = maze.goal;
  final numRows = map.length;
  final numColumns = map[0].length;

  final open = <Tile>[];
  final closed = <Tile>[];

  open.add(start);

  while (open.isNotEmpty) {
    var bestCost = open[0]._f;
    var bestTileIndex = 0;

    for (var i = 1; i < open.length; i++) {
      if (open[i]._f < bestCost) {
        bestCost = open[i]._f;
        bestTileIndex = i;
      }
    }

    var currentTile = open[bestTileIndex];

    if (currentTile == goal) {
      // queues are more performant when adding to the front
      final path = Queue<Tile>.from([goal]);

      // Go up the chain to recreate the path
      while (currentTile._parentIndex != -1) {
        currentTile = closed[currentTile._parentIndex];
        path.addFirst(currentTile);
      }

      return path;
    }

    open.removeAt(bestTileIndex);

    closed.add(currentTile);

    /* mark off untraversable tiles */
    List<List<int>> adjacentsCoordinates = [
      [currentTile.x, currentTile.y - 1],
      [currentTile.x, currentTile.y + 1],
      [currentTile.x - 1, currentTile.y],
      [currentTile.x + 1, currentTile.y],
    ]..removeWhere((pos) => pos[0] < 0 || pos[1] < 0 || pos[0] >= numColumns || pos[1] >= numRows);
    adjacentsCoordinates.forEach((pos) {
      Tile myTile = map[pos[1]][pos[0]];
      map[pos[1]][pos[0]] =
          new Tile(myTile.x, myTile.y, myTile.height, obstacle: currentTile.height + 1 < myTile.height);
    });

    for (var pos in adjacentsCoordinates) {
      int newX = pos[0];
      int newY = pos[1];
      if (!map[newY][newX].obstacle // If the new node is open
          ||
          (goal.x == newX && goal.y == newY && !map[newY][newX].obstacle)) {
        // or the new node is our destination
        //See if the node is already in our closed list. If so, skip it.
        var foundInClosed = false;
        for (var i = 0; i < closed.length; i++) {
          if (closed[i].x == newX && closed[i].y == newY) {
            foundInClosed = true;
            break;
          }
        }

        if (foundInClosed) {
          continue;
        }

        //See if the node is in our open list. If not, use it.
        var foundInOpen = false;
        for (var i = 0; i < open.length; i++) {
          if (open[i].x == newX && open[i].y == newY) {
            foundInOpen = true;
            break;
          }
        }

        if (!foundInOpen) {
          final tile = map[newY][newX].._parentIndex = closed.length - 1;

          tile
            .._g = currentTile._g + math.sqrt(math.pow(tile.x - currentTile.x, 2) + math.pow(tile.y - currentTile.y, 2))
            .._h = heuristic(tile, goal)
            .._f = tile._g + tile._h;

          open.add(tile);
        }
      }
    }
  }

  return Queue<Tile>();
}

class Day12 extends GenericDay {
  Day12() : super(12);

  @override
  Maze parseInput() {
    return Maze.parse(new InputUtil(12).asString);
  }

  @override
  int solvePart1() {
    Maze maze = parseInput();
    return aStar2D(maze).length - 1;
  }

  @override
  int solvePart2() {
    int best = 10000;
    Maze maze = parseInput();
    maze.tiles.forEach((List<Tile> row) => row.forEach((Tile tile) {
          if (tile.height == 0) {
            maze.start = tile;
            int len = aStar2D(maze).length - 1;
            if (len < best && len > 0) {
              best = len;
            }
          }
        }));
    return best;
  }
}
