import '../utils/index.dart';

class Day01 extends GenericDay {
  Day01() : super(1);

  @override
  parseInput() {
    return new InputUtil(1).getPerLine();
  }

  @override
  int solvePart1() {
    var lines = parseInput();
    int currentBest = 0;
    int currentBestIndex = -1;
    int current = 0;
    for (int i = 0; i < lines.length; i++) {
      if (lines[i] == '') {
        if (currentBest < current) {
          currentBest = current;
          currentBestIndex = i;
        }
        current = 0;
      } else {
        current += int.parse(lines[i]);
      }
    }
    return currentBest;
  }

  @override
  int solvePart2() {
    var lines = parseInput();
    List<int> allBest = [];
    int current = 0;
    for (int i = 0; i < lines.length; i++) {
      if (lines[i] == '') {
        allBest.add(current);
        current = 0;
      } else {
        current += int.parse(lines[i]);
      }
    }
    allBest.sort();
    var rankedBest = new List.from(allBest.reversed);
    var top3sum = rankedBest[0] + rankedBest[1] + rankedBest[2];
    return top3sum;
  }
}

void main() {
  print(Day01().solvePart1());
  print(Day01().solvePart2());
}
