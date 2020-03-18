import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:http/http.dart' as http;
import 'package:notive_app/models/item_model.dart';
import 'package:notive_app/models/list_model.dart';

String apiUrl = "http://139.59.155.177:5000/"; //temp

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
    print(response.body);
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
        body: json.encode(reqBody));
    updateCookie(response);
    final responseJson = json.decode(response.body);
    return [response.statusCode, responseJson];
  }
  else{
    return null;
  }
}

Future<List<dynamic>> sendFRequest(Map<String, String> params) async {
  var baseURL = "api.foursquare.com";
  var secondary = "/v2/venues/search";
  params["client_id"] = "CFOUGMPKOX5SNJK2LF4CWDBOBZKWS3G4BBF1BWJC3C5CBCXR";
  params["client_secret"] = "GCNWT1DEHDKT524H5YGNBAO25BA03S3LVFAYEXLEAO03UP0M";
  params["v"] = "20200101";

//  Position position = await Geolocator()
//        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//  String ll = position.latitude.toString() + ", " + position.longitude.toString();
//  params["ll"] = ll;

  var uriWithParams = Uri.https(baseURL, secondary, params);
  final response = await http.get(
    uriWithParams,
    headers: headers,
  );
  updateCookie(response);
  final responseJson = json.decode(response.body);
//  print("response");
//  print( response.statusCode);
//  print( responseJson);
  return [response.statusCode, responseJson];
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
    Map<String, dynamic> userDetails = {
      'user_id': userID,
      'email': email,
      'name': name
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
  await sendRequest('auth/logout', {}, 'GET');
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

Future<List<dynamic>> getUserItems() async {
  List<dynamic> response = await sendRequest('item', {}, 'GET');
  Map<String, dynamic> result = response[1];

  if (response[0] != 200) {
    return [response[0], result['message']];
  } else {
    Map<String,dynamic> returnItems = result['data'];
    return [response[0], result['message'], returnItems];
  }
}

Future<List<ListModel>> fillUserLists() async{
  // Get user lists for dashboard view 
  var listResponse = await getUserLists();
  if(listResponse[0] != 200){
    return [];
  }
  var lists = listResponse[2];

  // Get all items of a user as a hashmap, key: list_id
  var itemResponse = await getUserItems();
  if(itemResponse[0] != 200){
    return [];
  }

  var items = itemResponse[2];

  for(var i=0; i<lists.length; i++){
    var responseItems = items[(lists[i].id).toString()]; // Get respective list items 
    List<ItemModel> listItems = [];

    // convert dynamic list to Notive ItemModel list 
    if(responseItems != null){
      for (var i = 0; i < responseItems.length; i++) {
        ItemModel itemToAdd = ItemModel.fromJson(responseItems[i]);
//        String query = itemToAdd.name;
//        itemToAdd.setItemData(query);
        listItems.add(itemToAdd);
      }
    }
    // set items of the list 
    lists[i].setItems(listItems);
  }
  return lists;
}

Future<List<dynamic>> createUserList(Map<String, dynamic> data) async{
  List<dynamic> response = await sendRequest('list', data, 'POST');
  return [response[0], response[1]];
}

Future<List<dynamic>> createUserItem(Map<String, dynamic> data) async{
  List<dynamic> response = await sendRequest('item', data, 'POST');
  return [response[0], response[1]];
}

Future<List<dynamic>> deleteUserList(int listId) async{
  List<dynamic> response = await sendRequest('list/$listId', {}, 'DELETE');
  return [response[0], response[1]];
}

Future<List<dynamic>> deleteUserItem(int listId, int itemId) async{
  List<dynamic> response = await sendRequest('item/$listId/$itemId', {}, 'DELETE');
  return [response[0], response[1]];
}

Future<List<dynamic>> checkUserItem(ItemModel item) async{
  int listId = item.listId;
  int itemId = item.id;
  Map<String,dynamic> data = {};
  List<dynamic> response;
  response = await sendRequest('item/$listId/$itemId/check', data, 'PUT');
  return [response[0], response[1]];
}

//TODO
Future<List<dynamic>> updateUserList(Map<String, dynamic> data, int listId) async{
  List<dynamic> response = await sendRequest('list/$listId', data, 'PUT');
  return [response[0], response[1]];
}

//TODO
Future<List<dynamic>> updateUserItem(Map<String, dynamic> data, ItemModel item) async{
  var listId = item.listId;
  var itemId = item.id;
  List<dynamic> response = await sendRequest('item/$listId/$itemId', data, 'PUT');
  return [response[0], response[1]];
}

void updateCookie(http.Response response) {
  String rawCookie = response.headers['set-cookie'];
  if (rawCookie != null) {
    int index = rawCookie.indexOf(';');
    headers['cookie'] =
    (index == -1) ? rawCookie : rawCookie.substring(0, index);
  }
}




