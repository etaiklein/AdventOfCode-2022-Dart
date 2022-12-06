import '../utils/index.dart';

class Day04 extends GenericDay {
  Day04() : super(4);

  @override
  List<List<List<int>>> parseInput() {
    return new InputUtil(4).getPerLine().map((line) {
      return line.split(',').map((subline) {
        return subline.split('-').map(int.parse).toList();
      }).toList();
    }).toList();
  }

  bool doesFullyOverlap(rangeA, rangeB) => (
    (rangeB[0] <= rangeA[0] && rangeB[1] >= rangeA[1]) ||
    (rangeB[0] >= rangeA[0] && rangeB[1] <= rangeA[1])
  );

  bool doesPartiallyOverlap(rangeA, rangeB) => (
    (rangeA[0] <= rangeB[0] && rangeA[1] >= rangeB[0]) ||
    (rangeA[0] <= rangeB[1] && rangeA[1] >= rangeB[1]) ||
    (rangeA[0] >= rangeB[0] && rangeA[1] <= rangeB[1])
  );

  @override
  int solvePart1() {
    return parseInput().fold(0, (accumulator, element) => accumulator + (doesFullyOverlap(element[0], element[1]) ? 1 : 0));
  }

  @override
  int solvePart2() {
    return parseInput().fold(0, (accumulator, element) => accumulator + (doesPartiallyOverlap(element[0], element[1]) ? 1 : 0));
  }
}

