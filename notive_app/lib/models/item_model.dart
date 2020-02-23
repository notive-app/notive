class ItemModel {
  final int id;
  String name;
  bool isCompleted;
  int listId;
  int createdAt;

  ItemModel(
      {this.id, this.name, this.isCompleted, this.listId, this.createdAt });

  void checkCompletion() {
    isCompleted = !isCompleted;
  }

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
        id: json['id'],
        name: json['name'],
        isCompleted: false,//json['isCompleted']
        listId: json['list_id'],
        createdAt: json['created_at']
    );
  }
}
