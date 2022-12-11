import '../utils/index.dart';
import '../utils/field.dart';

class Day08 extends GenericDay {
  Day08() : super(8);

  @override
  Field<int> parseInput() {
    return Field<int>(
      new InputUtil(8).getPerLine().map((line) => line.split('').map(int.parse).toList()).toList()
    );
  }

  bool isTreeVisible(Field<int> input, Position p) {
    var north = input.getColumn(p.x).toList().slice(0, p.y);
    var south = input.getColumn(p.x).toList().slice(p.y + 1);
    var east = input.getRow(p.y).toList().slice(p.x + 1);
    var west = input.getRow(p.y).toList().slice(0, p.x);
    return [north, south, east, west].any((direction) => direction.length == 0 || direction.every((value) => value < input.getValueAtPosition(p)));
  }

  int getSceneryScore(Field<int> input, Position p) {
    var north = input.getColumn(p.x).toList().slice(0, p.y).toList();
    north = new List.from(north.reversed);
    var south = input.getColumn(p.x).toList().slice(p.y + 1).toList();
    var east = input.getRow(p.y).toList().slice(p.x + 1).toList();
    var west = input.getRow(p.y).toList().slice(0, p.x).toList();
    west = new List.from(west.reversed);

    return [north, west, south, east].map((direction) {
      int score = 0;
      for(var value in direction) {
        score += 1;
        if (value >= input.getValueAtPosition(p)) {
          break;
        }
      };
      return score;
    }).toList().reduce((a, b) => a * b);
  }

  @override
  int solvePart1() {
    Field<int> input = parseInput();
    int sum = 0;
    input.forEach((int x, int y) {
      sum += isTreeVisible(input, Position(x,y)) ? 1 : 0;
    });
    return sum;
  }

  @override
  int solvePart2() {
    Field<int> input = parseInput();
    int best = 0;
    input.forEach((int x, int y) {
      var current = getSceneryScore(input, Position(x,y));
      best = best > current ? best : current;
    });
    return best;
  }
}

