import 'dart:io';

/// Automatically reads reads the contents of the input file for given [day]. \
/// Note that file name and location must align.
class InputUtil {
  final String _inputAsString;
  final List<String> _inputAsList;

  InputUtil(int day, {sample = false})
      : _inputAsString = _readInputDay(day, sample: sample),
        _inputAsList = _readInputDayAsList(day, sample: sample);

  static String _createInputPath(int day, {sample = false}) {
    String dayString = day.toString().padLeft(2, '0');
    if (sample) {
      return './input/aoc$dayString-sample.txt';
    }
    return './input/aoc$dayString.txt';
  }

  static String _readInputDay(int day, {sample = false}) {
    return _readInput(_createInputPath(day, sample: sample));
  }

  static String _readInput(String input) {
    return File(input).readAsStringSync();
  }

  static List<String> _readInputDayAsList(int day, {sample = false}) {
    return _readInputAsList(_createInputPath(day, sample: sample));
  }

  static List<String> _readInputAsList(String input) {
    return File(input).readAsLinesSync();
  }

  /// Returns input as one String.
  String get asString => _inputAsString;

  /// Reads the entire input contents as lines of text.
  List<String> getPerLine() => _inputAsList;

  /// Splits the input String by `whitespace` and `newline`.
  List<String> getPerWhitespace() {
    return _inputAsString.split(RegExp(r'\s\n'));
  }

  /// Splits the input String by given pattern.
  List<String> getBy(String pattern) {
    return _inputAsString.split(pattern);
  }
}
