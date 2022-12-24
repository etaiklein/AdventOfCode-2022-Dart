import '../utils/index.dart';

class Day11 extends GenericDay {
  Day11() : super(11);

  @override
  parseInput() {
    var monkeys = {};
    new InputUtil(11).getBy('\n\n').forEach((business) {
      List<String> monkey = business.split('\n');

      // name
      int monkeyNumber = int.parse(monkey[0].split(":")[0].split("Monkey ")[1]); // e.g. 0

      // starting items
      List<double> startingItemsIntArray = monkey[1] // e.g. [79, 98]
          .split("Starting items: ")[1]
          .replaceAll(",", "")
          .split(" ")
          .map((item) => double.parse(item))
          .toList();

      // operation
      var operation = monkey[2].split("Operation: ")[1];
      var expressionA = operation.split(" = ")[0]; // e.g. 'new'
      var expressionB = operation.split(" = ")[1].split(" "); // e.g. ['old','*','19']

      // test
      var test = monkey[3].split("Test: ")[1];
      var testCondition = test.split(" "); // e.g. ['divisible', 'by' '23']
      var ifTrue = int.parse(monkey[4].split("   If true: throw to monkey ")[1]);
      var ifFalse = int.parse(monkey[5].split("   If false: throw to monkey ")[1]);

      monkeys[monkeyNumber] = {
        'currentItems': startingItemsIntArray,
        'operation': [expressionA, expressionB],
        'test': testCondition,
        'ifTrue': ifTrue,
        'ifFalse': ifFalse,
        'numberInspections': 0,
      };
    });
    return monkeys;
  }

  int getMonkeyMod(monkeys) {
    var monkeymod = 1;
    for (var i = 0; i < monkeys.length; i += 1) {
      monkeymod = monkeymod * int.parse(monkeys[i]['test'][2]);
    }
    return monkeymod;
  }

  dynamic advanceRound(monkeys, round, {shouldWorry = false}) {
    var monkeymod = getMonkeyMod(monkeys);
    for (var i = 0; i < monkeys.length; i += 1) {
      var currentMonkey = monkeys[i];
      // print("Monkey ${i}(${currentMonkey}) :");

      for (var j = 0; j < currentMonkey['currentItems'].length; j += 1) {
        // inspect
        double currentItem = currentMonkey['currentItems'][j];
        currentMonkey['currentItems'].remove(currentItem);
        j -= 1;
        // print("  Monkey inspects an item with a worry level of ${currentItem}:");
        currentMonkey['numberInspections'] += 1;

        // multiply worry level
        var multiplicand =
            currentMonkey['operation'][1][2] == "old" ? currentItem : int.parse(currentMonkey['operation'][1][2]);
        if (currentMonkey['operation'][1][1] == "+") {
          currentItem = currentItem + multiplicand;
        }
        if (currentMonkey['operation'][1][1] == "*") {
          currentItem = currentItem * multiplicand;
        }
        // print("    Worry level is ${currentMonkey['operation'][1][1]} by ${multiplicand} to ${currentItem}.");

        // get bored
        if (!shouldWorry) {
          currentItem = (currentItem / 3).floorToDouble();
          // print("    Monkey gets bored with item. Worry level is divided by 3 to ${currentItem}.");
        } else {
          currentItem = currentItem % monkeymod;
          // print("    Monkey gets bored with item. Worry level is divided by ${monkeymod} to ${currentItem}.");
        }

        // test condition
        int testCondition = int.parse(currentMonkey['test'][2]);
        bool testResult = (currentItem % int.parse(currentMonkey['test'][2])) == 0;
        // print("    Current worry level ${currentItem} is${testResult ? " " : " not "}divisible by ${testCondition}.");

        // pass item
        // print(
        //     "    Item with worry level ${currentItem} is thrown to monkey ${testResult ? currentMonkey['ifTrue'] : currentMonkey['ifFalse']}.");
        monkeys[testResult ? currentMonkey['ifTrue'] : currentMonkey['ifFalse']]['currentItems'].add(currentItem);
      }
      ;
    }
    return monkeys;
  }

  @override
  int solvePart1() {
    var monkeys = parseInput();
    String summary = "";
    var inspectorMonkey = 0;
    var deputyMonkey = 1;

    for (var i = 1; i < 21; i += 1) {
      monkeys = advanceRound(monkeys, i, shouldWorry: false);
      if (i != 20) {
        continue;
      }
      for (var i = 0; i < monkeys.length; i += 1) {
        summary +=
            "\nMonkey ${i}: ${monkeys[i]["currentItems"].join(", ")}. Monkey ${i} inspected ${monkeys[i]["numberInspections"]} times.";
        if (monkeys[inspectorMonkey]['numberInspections'] < monkeys[i]['numberInspections']) {
          deputyMonkey = inspectorMonkey;
          inspectorMonkey = i;
        } else if (monkeys[deputyMonkey]['numberInspections'] < monkeys[i]['numberInspections'] &&
            i != inspectorMonkey) {
          deputyMonkey = i;
        }
      }
    }
    // print("After round 20, the monkeys are holding items with these worry levels: ${summary}, ${inspectorMonkey},  ${deputyMonkey}");
    return monkeys[inspectorMonkey]['numberInspections'] * monkeys[deputyMonkey]['numberInspections'];
  }

  @override
  int solvePart2() {
    const rounds = 10000;
    var monkeys = parseInput();
    String summary = "";
    var inspectorMonkey = 0;
    var deputyMonkey = 1;

    for (var i = 1; i < rounds + 1; i += 1) {
      monkeys = advanceRound(monkeys, i, shouldWorry: true);
      if (i != rounds) {
        continue;
      }
      for (var i = 0; i < monkeys.length; i += 1) {
        summary += "\nMonkey ${i} inspected ${monkeys[i]["numberInspections"]} times.";
        if (monkeys[inspectorMonkey]['numberInspections'] < monkeys[i]['numberInspections']) {
          deputyMonkey = inspectorMonkey;
          inspectorMonkey = i;
        } else if (monkeys[deputyMonkey]['numberInspections'] < monkeys[i]['numberInspections'] &&
            i != inspectorMonkey) {
          deputyMonkey = i;
        }
      }
    }
    // print("After round ${rounds}, the monkeys are holding items with these worry levels: ${summary}");
    // print("inspector:${inspectorMonkey}, deputy:${deputyMonkey}");
    return monkeys[inspectorMonkey]['numberInspections'] * monkeys[deputyMonkey]['numberInspections'];
  }
}
