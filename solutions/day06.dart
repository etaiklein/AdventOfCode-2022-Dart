import '../utils/index.dart';

class Day06 extends GenericDay {
  Day06() : super(6);

  @override
  parseInput() {
    return new InputUtil(6).getBy('');
  }

  getUniqueChunkIndex(var input, int chunkSize) {
    for (var i = 0; i < input.length - chunkSize; i += 1) {
      if (input.sublist(i, i+chunkSize > input.length ? input.length : i + chunkSize).toSet().length == chunkSize){
        return i + chunkSize;
      }
    }
  }

  @override
  int solvePart1() {
    return getUniqueChunkIndex(parseInput(), 4);
  }

  @override
  int solvePart2() {
    return getUniqueChunkIndex(parseInput(), 14);
  }
}

