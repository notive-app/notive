class Item {
  final String itemString;
  bool isCompleted;

  Item({this.itemString, this.isCompleted = false});

  void checkCompletion() {
    isCompleted = !isCompleted;
  }
}
