class ItemModel {
  final int id;
  String name;
  bool isCompleted;
  int listId;

  ItemModel(
      {this.id = 0, this.name, this.isCompleted = false, this.listId = 0});

  void checkCompletion() {
    isCompleted = !isCompleted;
  }
}
