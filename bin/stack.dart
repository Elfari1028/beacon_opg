class Stack {
  List<int> data = [];
  void push(int i) {
    data.add(i);
  }

  void pop() {
    data.removeLast();
  }

  int top() {
    return data.last;
  }

  void pushStr(String str) {
    push(str.codeUnitAt(0));
  }

  int at(int i) {
    return data[i];
  }

  void setAt(int i,int val) {
    data[i] = val;
  }

  int get length {
    return data.length;
  }
}
