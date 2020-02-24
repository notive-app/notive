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
    bool flag = false;

    if(json['is_done'] == 1){
      flag = true;
    }
    return ItemModel(
        id: json['id'],
        name: json['name'],
        isCompleted: flag,
        listId: json['list_id'],
        createdAt: json['created_at']
    );
  }
}
