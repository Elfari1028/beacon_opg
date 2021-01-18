#include <stdio.h>
#include <stdlib.h>
#include <string.h>

const int CharacterNum = 10;

char line[2550];
char OLine[2550];
int stack[2550] = {0};
char CharacterNumList[1001] = {' ', '+', '*', 'i', '(', ')',
                               '#', 'N', 'F', 'T', 'E'};
int top = 0, lineLen = 0;
int prior[7][7];

int charToint(char c) {
  for (int i = 0; i <= CharacterNum; i++) {
    if (CharacterNumList[i] == c) {
      return i;
    }
  }
  return -1;
}

char intTochar(int i) { return CharacterNumList[i]; }

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

int main(int argc, char *argv[]) {
  FILE *fp = NULL;
  fp = fopen(argv[1], "r");
  fgets(OLine, 2000, (FILE *)fp);
  // printf(OLine);
  // lineLen=strlen(line);
  lineLen = 1;
  line[0] = '#';
  for (int i = 0; i < strlen(OLine); i++) {
    if (OLine[i] != '+' && OLine[i] != '*' && OLine[i] != 'i' &&
        OLine[i] != '(' && OLine[i] != ')' && OLine[i] != 'z') {
      continue;
    }
    line[lineLen] = OLine[i];
    lineLen++;
  }
  //在首尾分别添加#
  line[0] = '#';
  line[lineLen] = '#';
  line[lineLen + 1] = '\n';
  // printf(line);
  // printf("%d\n",lineLen);
  /*for (int i=0;i<10;i++)
  {
      printf("Character %d : %c;\n",i,CharacterNumList[i]);
  }*/

  setPrior();

  pushStack(charToint(line[0]));
  for (int i = 1; i <= lineLen;) {
    // printf("now: %c\n",line[i]);
    if (top == 2 && stack[1] == 7 && line[i] == '#') break;
    if (cmp(topTerminal(), charToint(line[i])) == 2) {
      printf("E\n");
      return 0;
    }
    if (cmp(topTerminal(), charToint(line[i])) == 1) {
      //规约
      int Status = specification();
      if (Status == 1) {
        printf("R\n");
      } else {
        if (Status == 2) {
          printf("RE\n");
          return 0;
        }
      }

    } else {
      //移入
      pushStack(charToint(line[i]));
      if (i == lineLen) break;
      printf("I%c\n", line[i]);
      i++;
    }
    // printf("top=%d\n",top);
    // printf("%d %d %d\n",stack[0],stack[1],stack[2]);
  }

  fclose(fp);
  return 0;
}