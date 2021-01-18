class StringBuilder {
  // ignore: prefer_final_fields
  List<String> _string = ['#', '#', '\n'];

  int get length => _string.length - 1;
  void add(String char) {
    _string.insert(length - 2, char);
  }

  String at(int i) {
    return _string[i];
  }

  int codeAt(int i) {
    return _string[i].codeUnitAt(0);
  }
}
