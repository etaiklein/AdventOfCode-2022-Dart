import '../utils/index.dart';

class Day10 extends GenericDay {
  Day10() : super(10);

  @override
  parseInput() {
    return new InputUtil(10).getPerLine();
  }

  @override
  int solvePart1() {
    List<int> results = [];
    var input = parseInput();
    int cycle = 0;
    int xRegister = 1;
    int nextRegister = 0;
    for (var i = 0; i < input.length + 1; i += 1) {
      cycle += 1;
      if ([20, 60, 100, 140, 180, 220].contains(cycle)) {
        results.add(cycle * xRegister);
      }
      if (nextRegister != 0) {
        xRegister += nextRegister;
        nextRegister = 0;
        i -= 1;
        continue;
      }
      if (i >= input.length ) {
        // print("cycle: ${cycle} xRegister: ${xRegister} nextRegister: ${nextRegister}");
        continue;
      }
      var split = input[i].split(' ');
      if (split.length > 1) {
        nextRegister = int.parse(split[1]);
      }
      // print("split: ${split} cycle: ${cycle} xRegister: ${xRegister} nextRegister: ${nextRegister}");
    }
    return results.reduce((a, b) => a + b);;
  }

  @override
  int solvePart2() {
    List<List<String>> screen = [];
    List<String> line = [];
    var input = parseInput();
    int cycle = 0;
    int xRegister = 1;
    int nextRegister = 0;
    for (var i = 0; i < input.length + 1; i += 1) {
      cycle += 1;
      line.add((line.length - xRegister).abs() < 2 ? "#" : ".");
      if ([40, 80, 120, 160, 200].contains(cycle)) {
        screen.add(new List<String>.from(line));
        line = [];
      }
      if (nextRegister != 0) {
        xRegister += nextRegister;
        nextRegister = 0;
        i -= 1;
        continue;
      }
      if (i >= input.length ) {
        // print("cycle: ${cycle} xRegister: ${xRegister} nextRegister: ${nextRegister}");
        screen.add(new List<String>.from(line));
        continue;
      }
      var split = input[i].split(' ');
      if (split.length > 1) {
        nextRegister = int.parse(split[1]);
      }
      // print("split: ${split} cycle: ${cycle} xRegister: ${xRegister} nextRegister: ${nextRegister}");
    }
    screen.forEach((line) => print(line.join('')));
    return 0;
  }
}

