import 'dart:convert';
import 'dart:io';

const int characterNum = 10;

List<String> line = [];
List<String> original = [];
List<int> stack = [];
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
int top = 0, lineLen = 0;
List<List<int>> prior = [];

int charToint(String c) {
  for (int i = 0; i <= characterNum; i++) {
    if (characterNumList[i] == c) {
      return i;
    }
  }
  return -1;
}

String intTochar(int i) {
  return characterNumList[i];
}

void pushStack(int newStackNum) {
  stack[top] = newStackNum;
  top++;
}

int popStack() {
  top--;
  return stack[top];
}

void setPrior() {
  prior[1][1] = 1;
  prior[1][2] = -1;
  prior[1][3] = -1;
  prior[1][4] = -1;
  prior[1][5] = 1;
  prior[1][6] = 1;

  prior[2][1] = 1;
  prior[2][2] = 1;
  prior[2][3] = -1;
  prior[2][4] = -1;
  prior[2][5] = 1;
  prior[2][6] = 1;

  prior[3][1] = 1;
  prior[3][2] = 1;
  prior[3][3] = 2;
  prior[3][4] = 2;
  prior[3][5] = 1;
  prior[3][6] = 1;

  prior[4][1] = -1;
  prior[4][2] = -1;
  prior[4][3] = -1;
  prior[4][4] = -1;
  prior[4][5] = 0;
  prior[4][6] = 2;

  prior[5][1] = 1;
  prior[5][2] = 1;
  prior[5][3] = 2;
  prior[5][4] = 2;
  prior[5][5] = 1;
  prior[5][6] = 1;

  prior[6][1] = -1;
  prior[6][2] = -1;
  prior[6][3] = -1;
  prior[6][4] = -1;
  prior[6][5] = 2;
  prior[6][6] = 2;
}

int cmp(int a, int b) {
  if (a >= 0 && a <= 6 && b >= 0 && b <= 6)
    return prior[a][b];
  else
    return 2;
}

int topTerminal() {
  for (int i = top - 1; i >= 0; i--) {
    if (stack[i] <= 6 && stack[i] >= 0) return stack[i];
  }
}

int specification() {
  if (stack[top - 1] == 3) {
    stack[top - 1] = 7;
    return 1;
  }
  if (stack[top - 1] == 7 && stack[top - 2] == 1 && stack[top - 3] == 7) {
    top = top - 2;
    stack[top - 1] = 7;
    return 1;
  }
  if (stack[top - 1] == 7 && stack[top - 2] == 2 && stack[top - 3] == 7) {
    top = top - 2;
    stack[top - 1] = 7;
    return 1;
  }
  if (stack[top - 1] == 5 && stack[top - 2] == 7 && stack[top - 3] == 4) {
    top = top - 2;
    stack[top - 1] = 7;
    return 1;
  }
  return 2;
}

void main(List<String> args) {
  File fin = new File(args[0]); //转入的文件对象
  Stream<List<int>> inputStream = fin.openRead();
  String lines = "";
  inputStream
      .transform(utf8.decoder) // Decode bytes to UTF-8.
      .transform(new LineSplitter()) // Convert stream to individual lines.
      .listen((String line) {
    // Process results.
    // line = line.replaceAll("\r", "");
    lines += line;
    stdout.write(line);
  }, onDone: () {
    original = lines.split('');
    proc();
  });
}

int proc() {
  lineLen = 1;
  line[0] = '#';
  for (int i = 0; i < original.length; i++) {
    if (original[i] != '+' &&
        original[i] != '*' &&
        original[i] != 'i' &&
        original[i] != '(' &&
        original[i] != ')' &&
        original[i] != 'z') {
      continue;
    }
    line[lineLen] = original[i];
    lineLen++;
  }
  //在首尾分别添加#
  line[0] = '#';
  line[lineLen] = '#';
  line[lineLen + 1] = '\n';
  //stdout.write(line);
  //stdout.write("%d\n",lineLen);
  /*for (int i=0;i<10;i++)
    {
        stdout.write("Character %d : %c;\n",i,characterNumList[i]);
    }*/

  setPrior();

  pushStack(charToint(line[0]));
  for (int i = 1; i <= lineLen;) {
    //stdout.write("now: %c\n",line[i]);
    if (top == 2 && stack[1] == 7 && line[i] == '#') break;
    if (cmp(topTerminal(), charToint(line[i])) == 2) {
      stdout.write("E\n");
      return 0;
    }
    if (cmp(topTerminal(), charToint(line[i])) == 1) {
      //规约
      int status = specification();
      if (status == 1) {
        stdout.write("R\n");
      } else {
        if (status == 2) {
          stdout.write("RE\n");
          return 0;
        }
      }
    } else {
      //移入
      pushStack(charToint(line[i]));
      if (i == lineLen) break;
      stdout.write("I" + line[i] + "\n");
      i++;
    }
    //stdout.write("top=%d\n",top);
    //stdout.write("%d %d %d\n",stack[0],stack[1],stack[2]);
  }
  return 0;
}
