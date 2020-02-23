import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:notive_app/models/item_model.dart';
import 'package:notive_app/models/list_model.dart';

String apiUrl = "http://127.0.0.1/"; //temp

Map<String, String> headers = {
  'Content-type': 'application/json',
  'Accept': 'application/json',
  'Authorization':
  'Bearer P342A8HtvavVuSDNKV2fMd9TZctxVLs8Cw2I2nfi6HlMIUFPc51MV66zYdwOPUno'
};


Future<List<dynamic>> sendRequest(
    String url, Map<String, dynamic> reqBody, String method) async {
  if (method == "POST") {
    final response = await http.post(apiUrl + url,
        headers: headers,
        body: json.encode(reqBody));
    updateCookie(response);
    final responseJson = json.decode(response.body);
    return [response.statusCode, responseJson];
  }
  else if (method == "GET") {
    final response = await http.get(
      apiUrl + url,
      headers: headers,
    );
    updateCookie(response);
    final responseJson = json.decode(response.body);
    return [response.statusCode, responseJson];
  }
  else if (method == "DELETE") {
    final response = await http.delete(
      apiUrl + url,
      headers: headers,
    );
    updateCookie(response);
    final responseJson = json.decode(response.body);
    return [response.statusCode, responseJson];
  }
  else if (method == "PUT") {
    final response = await http.put(apiUrl + url,
        headers: headers,
        body: reqBody);
    updateCookie(response);
    final responseJson = json.decode(response.body);
    return [response.statusCode, responseJson];
  }
  else{
    return null;
  }
}

Future<List<dynamic>> loginUser(Map<String, dynamic> data) async {
  List<dynamic> response = await sendRequest('auth/login', data, 'POST');
  Map<String, dynamic> result = response[1]; // Response from API.
  if (response[0] != 200) {
    // Status code from API.
    return [response[0], result['message']]; // Return error message from API.
  } else {
    String message = result['message'];
    int userID = result['data']['user']['id'];
    String email = result['data']['user']['email'];
    String name = result['data']['user']['name'];
    String surname = result['data']['user']['surname'];
    Map<String, dynamic> userDetails = {
      'user_id': userID,
      'email': email,
      'name': name,
      'surname': surname
    };
    return [response[0], message, userDetails];
  }
}

Future<List<dynamic>> signUpUser(Map<String, dynamic> data) async {
  List<dynamic> response = await sendRequest('auth/register', data, 'POST');
  Map<String, dynamic> result = response[1]; //Response from API.
  return [response[0], result['message']]; //Return error message from API.
}

void logoutUser() async {
  await sendRequest('/logout', {}, 'POST');
}

Future<List<dynamic>> getUserLists() async {
  List<dynamic> response = await sendRequest('list/', {}, 'GET');
  Map<String, dynamic> result = response[1];
  if (response[0] != 200) {
    return [response[0], result['message']];
  } else {
    List<ListModel> lists = [];
    List<dynamic> returnLists = result['data']['lists'];

    for (var i = 0; i < returnLists.length; i++) {
      lists.add(ListModel.fromJson(returnLists[i]));
    }
    return [response[0], result['message'], lists];
  }
}

Future<List<dynamic>> getUserListItems(int listId) async {
  List<dynamic> response = await sendRequest('item/$listId', {}, 'GET');
  Map<String, dynamic> result = response[1];

  if (response[0] != 200) {
    return [response[0], result['message']];
  } else {

    List<ItemModel> items = [];
    List<dynamic> returnItems = result['data']['items'];

    for (var i = 0; i < returnItems.length; i++) {
      items.add(ItemModel.fromJson(returnItems[i]));
    }

    return [response[0], result['message'], items];
  }
}

Future<List<ListModel>> fillUserLists() async{
  var response = await getUserLists();

  if(response[0] != 200){
    return [];
  }

  var lists = response[2];

  for (var i=0; i<lists.length; i++) {
    response = await getUserListItems(lists[i].id);

    if(response[0] == 200){
      var items = response[2];
      lists[i].setItems(items);
    }
  }
  return lists;
}

void updateCookie(http.Response response) {
  String rawCookie = response.headers['set-cookie'];
  if (rawCookie != null) {
    int index = rawCookie.indexOf(';');
    headers['cookie'] =
    (index == -1) ? rawCookie : rawCookie.substring(0, index);
  }
}

Future<List<int>> createList(Map<String, dynamic> data) async{
  List<dynamic> response = await sendRequest('list/create', data, 'POST');

  if(response[0] == 200){
    return [response[1]['data']['list_id'],response[1]['data']['created_at']];
  }else{
    throw Exception;
  }
}

Future<List<int>> createItem(Map<String, dynamic> data) async{
  List<dynamic> response = await sendRequest('item/create', data, 'POST');

  if(response[0] == 200){
    return [response[1]['data']['item_id'],response[1]['data']['created_at']];
  }else{
    throw Exception;
  }
}

