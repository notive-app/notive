import 'dart:collection';
import 'package:notive_app/models/item_model.dart';

class ListModel {
  final int id;
  String name;
  int userId;
  bool isDone;
  int createdAt;
  int finishedAt;
  List<ItemModel> _items = [];
  bool isArchived;

  ListModel({this.id, this.name, this.userId, this.isDone, this.createdAt, this.isArchived});

  UnmodifiableListView<ItemModel> get items {
    return UnmodifiableListView(_items);
  }

  List<ItemModel> getItems(){
    return _items; 
  }
  
  int get itemsCount {
    return _items.length;
  }

  void setItems(List<ItemModel> items) {
    this._items = items;
  }

  void addItem(ItemModel item) {
    _items.add(item);
  }

  void checkItem(ItemModel item) {
    item.checkCompletion();
  }

  void deleteItem(ItemModel item) {
    _items.remove(item);
    
  }

  void setName(String newName) {
    name = newName;
  }

  void setArchived(bool archiveCondition){
    isArchived = archiveCondition;
  }

  factory ListModel.fromJson(Map<String, dynamic> json) {
    bool flag = false;

    if(json['is_done'] == 1){
      flag = true;
    }

    return ListModel(
      id: json['id'],
      name: json['name'],
      userId: json['user_id'],
      isDone: flag,
      createdAt: json['created_at']
    );
  }
}
