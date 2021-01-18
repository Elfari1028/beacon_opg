import 'dart:convert';
import 'dart:io';

import 'stack.dart';
import 'str_builder.dart';

List<String> characterNumList = [
  ' ',
  '+',
  '*',
  'i',
  '(',
  ')',
  '#',
  'N',
  'F',
  'T',
  'E'
];

int charToInt(String c) {
  for (int i = 0; i <= 10; i++) {
    if (characterNumList[i] == c) {
      return i;
    }
  }
  return -1;
}

String intToChar(int i) {
  return characterNumList[i];
}

List<List<dynamic>> priority = [
  [],
  [0, 1, -1, -1, -1, 1, 1],
  [0, 1, 1, -1, -1, 1, 1],
  [0, 1, 1, 2, 2, 1, 1],
  [0, -1, -1, -1, -1, 0, 2],
  [0, 1, 1, 2, 2, 1, 1],
  [0, -1, -1, -1, -1, 2, 2],
];
void main(List<String> args) {
  init(inputPath: args[0], onDone: process);
}

void init({String inputPath, Function(String) onDone}) {
  File fin = new File(inputPath); //转入的文件对象
  Stream<List<int>> inputStream = fin.openRead();
  String lines = "";
  inputStream
      .transform(utf8.decoder) // Decode bytes to UTF-8.
      .transform(new LineSplitter()) // Convert stream to individual lines.
      .listen((String line) {
    // Process results.
    // line = line.replaceAll("\r", "");
    lines += line;
    print(line);
  }, onDone: () {
    process(lines);
  });
}

Stack stack = Stack();
void process(String input) {
  StringBuilder builder = StringBuilder();
  List<String> chars = input.split('');
  chars.forEach((element) {
    if (element != '+' &&
        element != '*' &&
        element != 'i' &&
        element != '(' &&
        element != ')' &&
        element != 'z') {
      // do nothing
    } else {
      builder.add(element);
    }
  });
  stack.push(charToInt(builder.at(0)));
  for (int i = 1; i <= builder.length;) {
    if (stack.top() == 2 && stack.at(1) == 7 && builder.at(i) == '#') {
      break;
    }
    if (compare(topTerminal(), charToInt(builder.at(i))) == 2) {
      print('E\n');
      return;
    } else if (compare(topTerminal(), charToInt(builder.at(i))) == 1) {
      int status = specification();
      if (status == 1) {
        print("R\n");
      } else {
        if (status == 2) {
          print("RE\n");
          return;
        }
      }
    } else {
      stack.push(charToInt(builder.at(i)));
      if (i == builder.length) break;
      print('I' + builder.at(i) + "\n");
      i++;
    }
  }
}

int topTerminal() {
  for (int i = stack.length - 1; i >= 0; i--) {
    if (stack.at(i) <= 6 && stack.at(i) >= 0) return stack.at(i);
  }
}

int specification() {
  int pri = stack.length - 1;
  int sec = stack.length - 2;
  int tri = stack.length - 3;
  if (stack.at(pri) == 3) {
    stack.setAt(pri, 7);
    return 1;
  }
  if (stack.at(pri) == 7 && stack.at(sec) == 1 && stack.at(tri) == 7) {
    stack.pop();
    stack.pop();
    pri -= 2;
    stack.setAt(pri, 7);
    return 1;
  }
  if (stack.at(pri) == 7 && stack.at(sec) == 2 && stack.at(tri) == 7) {
    stack.pop();
    stack.pop();
    pri -= 2;
    stack.setAt(pri, 7);
    return 1;
  }
  if (stack.at(pri) == 5 && stack.at(sec) == 7 && stack.at(tri) == 4) {
    stack.pop();
    stack.pop();
    pri -= 2;
    stack.setAt(pri, 7);
    return 1;
  }
  return 2;
}

int compare(int a, int b) {
  if (a >= 0 && a <= 6 && b >= 0 && b <= 6) {
    return priority[a][b];
  } else {
    return 2;
  }
}
