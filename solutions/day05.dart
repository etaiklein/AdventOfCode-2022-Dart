import '../utils/index.dart';

class Day05 extends GenericDay {
  Day05() : super(5);

  @override
  parseInput() {
    return new InputUtil(5).getBy('\n\n');
  }

  List<List<String>> parseCrates(crateInput) {
    List<List<String>> crates = [[],[],[],[],[],[],[],[],[]]; // 9 crates
    crateInput.split('\n').forEach((line) {
      for (var i = 0; i < line.length; i += 4) {
        var substring = line.substring(i, i + 4 > line.length ? line.length : i + 4).trim();
        if (RegExp(r'[a-zA-Z]').hasMatch(substring)) {
          crates[i~/4].add(substring);
          // print("line ${substring} ${i} ${i~/4} added to crate ${i~/4}, ${crates[i~/4]}");
        }
      }
    });
    return crates;
  }

  List<List<String>> moveCrates(crates, movesInput, shouldReverse) {
    movesInput.split('\n').forEach((line) {
      Iterable<RegExpMatch> matches = RegExp(r'\b([0-9]|[1-9][0-9])\b').allMatches(line);
      int amount = int.parse(matches.elementAt(0).group(0) ?? '-1');
      int source = int.parse(matches.elementAt(1).group(0) ?? '-1') - 1;
      int destination = int.parse(matches.elementAt(2).group(0) ?? '-1') - 1;
      // print("move ${amount} from ${source} to ${destination}");
      // print("moving ${crates[source].take(amount)} from ${source}:${crates[source]} to ${destination}:${crates[destination]}");
      var movingCrates = crates[source].take(amount);
      shouldReverse
        ? crates[destination].insertAll(0, movingCrates.toList().reversed)
        : crates[destination].insertAll(0, movingCrates.toList());
      crates[source].removeRange(0, amount);
      // print("moved ${crates[destination].take(amount)} from ${source}:${crates[source]} to ${destination}:${crates[destination]}");
    });
    return crates;
  }

  @override
  int solvePart1() {
    var input = parseInput();
    var crates = parseCrates(input[0]);
    crates = moveCrates(crates, input[1], false);
    print(crates.fold("", (accumulator, crate) => accumulator = "${accumulator}${crate[0]}"));
    return 0;
  }

  @override
  int solvePart2() {
    var input = parseInput();
    var crates = parseCrates(input[0]);
    crates = moveCrates(crates, input[1], true);
    print(crates.fold("", (accumulator, crate) => accumulator = "${accumulator}${crate[0]}"));
    return 0;
  }
}

