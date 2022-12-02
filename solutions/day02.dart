import '../utils/index.dart';

class Day02 extends GenericDay {
  Day02() : super(2);

  @override
  parseInput() {
    return new InputUtil(2).getPerLine();
  }

  // A for Rock, B for Paper, and C for Scissors
  // X for Rock, Y for Paper, and Z for Scissors
  // My score: +1 for Rock, +2 for Paper, and +3 for Scissors
  // My score: +0 if you lost, +3 if the round was a draw, and +6 if you won

  // Map: AX: 4, AY: 8, AZ: 3, BX: 1, BY: 5, BZ: 9, CX: 7, CY: 2, CZ: 6
  @override
  int solvePart1() {
    Map<String, int> scoremap = {
      "A X": 4,
      "A Y": 8,
      "A Z": 3,
      "B X": 1,
      "B Y": 5,
      "B Z": 9,
      "C X": 7,
      "C Y": 2,
      "C Z": 6
    };
    int score = 0;
    var lines = parseInput();
    for (int i = 0; i < lines.length; i++) {
      if (scoremap.containsKey(lines[i])) {
        score += scoremap[lines[i]]!;
      } else {
        print("missing scoremap entry");
      }
    }
    return score;
  }

  // X means you need to lose, Y means you need to end the round in a draw, and Z means you need to win
  // in other words .... X = choose bad, Y = choose same, Z = choose good
  // My score: +1 for Rock, +2 for Paper, and +3 for Scissors
  // My score: +0 if you lost, +3 if the round was a draw, and +6 if you won

  @override
  int solvePart2() {

    Map<String, int> scoremap = {
      "A X": 3, // rock scissors lose = 3
      "A Y": 4, // rock rock tie = 4
      "A Z": 8, // rock paper win = 8
      "B X": 1, // paper rock lose = 1
      "B Y": 5, // paper paper tie = 5
      "B Z": 9, // paper scissors win = 9
      "C X": 2, // scissors paper lose = 2
      "C Y": 6, // scissors scissors tie = 6
      "C Z": 7  // scissors rock win = 7
    };
    int score = 0;
    var lines = parseInput();
    for (int i = 0; i < lines.length; i++) {
      if (scoremap.containsKey(lines[i])) {
        score += scoremap[lines[i]]!;
      } else {
        print("missing scoremap entry");
      }
    }
    return score;
  }
}