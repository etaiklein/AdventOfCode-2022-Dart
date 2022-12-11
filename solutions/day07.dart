import '../utils/index.dart';
import 'dart:io';
import 'package:file/file.dart';
import 'package:file/memory.dart';

class Day07 extends GenericDay {
  Day07() : super(7);

  @override
  parseInput() {
    return new InputUtil(7).getPerLine();
  }

  void createHelloWorldFile(FileSystem fileSystem) {
    final file = fileSystem.file('generated/hello_world.dart');
    file.createSync(recursive: true);
  }

  void addDirectory(MemoryFileSystem fs, String dirname) async {
    var myDir = fs.directory(dirname);
    var doesExist = await myDir.exists();
    if (!doesExist) {
      // print("addDirectory ${dirname}");
      myDir.createSync();
    }
  }

  void addFile(MemoryFileSystem fs, String filename, String size) {
    // print("addFile ${filename}, ${size}");
    File file = fs.file(filename);
    file.createSync(recursive: true);
    file.writeAsString(size);
  }

  Future<int> getSizeOfDirectory(MemoryFileSystem fs, String path) async {
    var currentDirectory = fs.directory(path);
    int size = 0;
    await for (var entity in fs.directory(path).list(recursive: true, followLinks: false)) {
      if (entity is File) {
        String contents = await (entity as File).readAsString();
        size+= int.parse(contents);
      }
    }
    return size;
  }

  void getFileTree(int part) async {
    var input = parseInput();
    MemoryFileSystem fs = new MemoryFileSystem();
    var path = "";
    for (var i = 0; i < input.length; i += 1) {
      var line = input[i];
      var splitLine = line.split(' ');
      if (splitLine[0] == "\$") {
        if (splitLine[1] == "cd") {
          if (splitLine[2] == "..") {
            path = fs.directory(path).parent.path;
          } else {
            var nextPath = (path + "/" + splitLine[2]).replaceAll("//", "/");
            addDirectory(fs, nextPath);
            path = nextPath;
          }
        }
        if (splitLine[1] == "ls") {
          while(i+1 < input.length && input[i+1][0] != "\$") {
            // print("bumping i from ${i} to ${i+1}");
            i = i+1;
            line = input[i];
            splitLine = line.split(' ');
            var nextPath = (path + "/" + splitLine[1]).replaceAll("//", "/");
            if (splitLine[0] == "dir") {
              addDirectory(fs, nextPath);
            } else {
              addFile(fs, nextPath, splitLine[0]);
            }
          }
        }
      }
    }
    if (part == 1){
      printFileTreePart1(fs);
    } else if (part == 2) {
      printFileTreePart2(fs);
    }
  }

  void printFileTreePart1(MemoryFileSystem fs) async {
    int maxSize = 100000;
    List<String> entities = [];
    int sum = 0;
    await for (var entity in fs.directory("/").list(recursive: true, followLinks: false)) {
      if (entity is Directory) {
        int dirSize = await getSizeOfDirectory(fs, (entity as Directory).path);
        if (dirSize < maxSize) {
          sum = sum + dirSize;
          // entities.add("${(entity as Directory).path} (dir, size=${dirSize})");
        // } else {
          // entities.add("${(entity as Directory).path} (dir)");
        }
      }
      // if (entity is File) {
        // var fileContents = await (entity as File).readAsString();
        // entities.add("${(entity as File).path} (file)");
      // }
    }
    // entities.sort();
    // print("- / (dir)");
    // entities.forEach((e) {
      // print("  " * (e.split('/').length) + "- " + e.split('/')[e.split('/').length-1]);
    // });
    print("part 1: ${sum}");
  }

  void printFileTreePart2(MemoryFileSystem fs) async {
    int totalDirSize = await getSizeOfDirectory(fs, "/");
    int remainingDirSize = 30000000 - (70000000 - totalDirSize);

    List<String> entities = [];
    await for (var entity in fs.directory("/").list(recursive: true, followLinks: false)) {
      if (entity is Directory) {
        int dirSize = await getSizeOfDirectory(fs, (entity as Directory).path);
        if (dirSize > remainingDirSize) {
          entities.add("${dirSize} - ${(entity as Directory).path} (dir, size=${dirSize})");
        }
      }
    }
    entities.sort((a,b) => (int.parse(a.split(" - ")[0]) > int.parse(b.split(" - ")[0])) ? 1 : 0);
    print("part 2: ${int.parse(entities[0].split(" - ")[0])}");
  }

  @override
  int solvePart1() {
    getFileTree(1);
    return 0;
  }

  @override
  int solvePart2() {
    getFileTree(2);
    return 0;
  }
}
