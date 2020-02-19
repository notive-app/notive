import 'dart:async';
import 'dart:convert';
//import 'dart:io';

import 'package:http/http.dart' as http;

String apiUrl = "http://139.179.206.249/"; //temp

Future<List<dynamic>> sendRequest(
    String url, Map<String, dynamic> reqBody, String method) async {
  if (method == "POST") {
    final response = await http.post(apiUrl + url,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization':
              'Bearer P342A8HtvavVuSDNKV2fMd9TZctxVLs8Cw2I2nfi6HlMIUFPc51MV66zYdwOPUno'
        },
        body: json.encode(reqBody));
    final responseJson = json.decode(response.body);
    return [response.statusCode, responseJson];
  }

  if (method == "GET") {
    final response = await http.get(
      apiUrl + url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization':
            'Bearer P342A8HtvavVuSDNKV2fMd9TZctxVLs8Cw2I2nfi6HlMIUFPc51MV66zYdwOPUno'
      },
    );
    final responseJson = json.decode(response.body);
    return responseJson;
  }

  if (method == "DELETE") {
    final response = await http.delete(
      apiUrl + url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization':
            'Bearer P342A8HtvavVuSDNKV2fMd9TZctxVLs8Cw2I2nfi6HlMIUFPc51MV66zYdwOPUno'
      },
    );
    final responseJson = json.decode(response.body);
    return responseJson;
  }

  if (method == "PUT") {
    final response = await http.put(apiUrl + url,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization':
              'Bearer P342A8HtvavVuSDNKV2fMd9TZctxVLs8Cw2I2nfi6HlMIUFPc51MV66zYdwOPUno'
        },
        body: reqBody);
    final responseJson = json.decode(response.body);
    return responseJson;
  }

  //??
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

Future<List<dynamic>> signupUser(Map<String, dynamic> data) async {
  List<dynamic> response = await sendRequest('auth/register', data, 'POST');
  Map<String, dynamic> result = response[1]; //Response from API.
  if (response[0] != 200) {
    //Status code from API.
    return [response[0], result['message']]; //Return error message from API.
  } else {
    String message = result['message'];
    int userID = result['data']['lists']['id'];
    //String
  }
}

Future<List<dynamic>> getUserLists(Map<String, dynamic> data) async {
  List<dynamic> response = await sendRequest('list', data, 'GET');
  Map<String, dynamic> result = response[1];
  if (response[0] != 200) {
    return [response[0], result['message']];
  } else {
    String message = result['message'];
  }
}
