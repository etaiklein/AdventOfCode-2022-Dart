import '../utils/index.dart';

class Day03 extends GenericDay {
  Day03() : super(3);

  @override
  parseInput() {
    return new InputUtil(3).getPerLine();
  }

  int getPriority(c) {
    return c.codeUnitAt(0) - 64 + ((c.toUpperCase() == c) ? 26 : -32);
  }

  Set getCommonElements(list) {
    return list.fold<dynamic>(list.first.toSet(), (a, b) => a.intersection(b.toSet()));
  }

  @override
  int solvePart1() {
    // test priority helper
    assert(getPriority('a') == 1);
    assert(getPriority('z') == 26);
    assert(getPriority('A') == 27);
    assert(getPriority('Z') == 52);

    var lines = parseInput();

    // get priority of common elements
    return lines.map((line) {
      var compartments = [line.split('').sublist(0, line.length ~/ 2), line.split('').sublist(line.length ~/ 2, line.length)];
      return getPriority(getCommonElements(compartments).first);
    }).toList().reduce(((value, element) => value + element));
  }

  @override
  int solvePart2() {
    var lines = parseInput();

    // build groups of 3
    var groups = [];
    for (var i = 0; i < lines.length; i += 3) {
      groups.add(lines.sublist(i, i + 3 > lines.length ? lines.length : i + 3));
    }

    // get priority of common elements
    return groups.map((group) {
      var lineSets = group.map((lines) => lines.split('')).toList();
      return getPriority(getCommonElements(lineSets).first);
    }).toList().reduce(((value, element) => value + element));
  }
}

