import '../utils/index.dart';
import 'dart:convert';

class Day13 extends GenericDay {
  Day13() : super(13);

  @override
  parseInput() {
    return new InputUtil(13, sample: false)
        .getBy('\n\n')
        .map((pair) => pair.split("\n").map((packet) {
              return json.decode(packet);
            }).toList())
        .toList();
  }

  int comparePackets(left, right) {
    if (left.runtimeType == int) {
      left = [left];
    }
    if (right.runtimeType == int) {
      right = [right];
    }

    for (int j = 0; j < left.length && j < right.length; j += 1) {
      var l = left[j];
      var r = right[j];
      // print("l ${l}, r ${r}");

      if (l.runtimeType == int && r.runtimeType == int) {
        if (l < r) {
          // print("Left side is smaller, so inputs are in the right order");
          return 1;
        }
        if (l > r) {
          // print("Right side is smaller, so inputs are not in the right order");
          return -1;
        }
      }
      if (l.runtimeType == int && r.runtimeType == List) {
        var c = comparePackets([l], r);
        if (c != 0) {
          return c;
        }
      }
      if (l.runtimeType == List && r.runtimeType == int) {
        var c = comparePackets(l, [r]);
        if (c != 0) {
          return c;
        }
      }
      if (l.runtimeType == List && r.runtimeType == List) {
        var c = comparePackets(l, r);
        if (c != 0) {
          return c;
        }
      }
    }
    if (left.length < right.length) {
      // print("Left side ran out of items, so inputs are in the right order");
      return 1;
    }
    if (left.length > right.length) {
      // print("Right side ran out of items, so inputs are not in the right order");
      return -1;
    }
    return 0;
  }

  @override
  int solvePart1() {
    var signal = parseInput();
    int i = 0;
    int sum = 0;
    signal.forEach((packet) {
      i++;
      var left = packet[0];
      var right = packet[1];
      var result = comparePackets(left, right);
      // print("Pair ${i} ${result > 0 ? true : false}, ${left}, ${right}");
      if (result > 0 ? true : false) {
        sum += i;
      }
    });
    return sum;
  }

  @override
  int solvePart2() {
    var signal = parseInput();
    var dividerA = [2];
    var dividerB = [6];
    var packets = [
      dividerA,
      dividerB,
      ...signal.map((s) => s[0]).toList(),
      ...signal.map((s) => s[1]).toList(),
    ];
    packets.sort(comparePackets);
    var reversedList = new List.from(packets.reversed);
    // reversedList.forEach(print);
    return (reversedList.indexOf(dividerA) + 1) * (reversedList.indexOf(dividerB) + 1);
  }
}
