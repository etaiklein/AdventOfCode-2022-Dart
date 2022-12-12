import '../utils/index.dart';
import 'dart:math';

var directions = {
  'D': Point(0, -1),
  'L': Point(-1, 0),
  'R': Point(1, 0),
  'U': Point(0, 1),
};

class Day09 extends GenericDay {
  Day09() : super(9);

  @override
  parseInput() {
    return new InputUtil(9).getPerLine();
  }

  moveRope(lines, length) {
    var rope = List.generate(length, (index) => Point(0, 0));
    var tailSet = {rope.last};

    moveKnot(int ix) {
      var delta = rope[ix - 1] - rope[ix];
      if (delta.x.abs() <= 1 && delta.y.abs() <= 1) {
        return;
      }
      rope[ix] += Point(delta.x.sign, delta.y.sign);
    }

    for (var move in lines) {
      var splitMove = move.split(' ');
      for (var i = 0; i < int.parse(splitMove[1]); i++) {
        rope[0] += directions[splitMove[0]]!;
        for (var j = 1; j < rope.length; j++) {
          moveKnot(j);
        }
        tailSet.add(rope.last);
      }
    }
    return tailSet.length;
  }

  @override
  int solvePart1() {
    var input = parseInput();
    return moveRope(input, 2);
  }

  @override
  int solvePart2() {
    var input = parseInput();
    return moveRope(input, 10);
  }
}