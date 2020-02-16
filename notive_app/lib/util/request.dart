import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
String apiUrl = "http://139.179.206.249/"; //temp

Future <List<dynamic>> sendRequest(String url, Map<String,dynamic> reqBody, String method) async {
  
  if (method == "POST"){
    final response = await http.post(
      apiUrl + url,
      headers: {'Content-type':'application/json',
      'Accept':'application/json',
      'Authorization': 'Bearer P342A8HtvavVuSDNKV2fMd9TZctxVLs8Cw2I2nfi6HlMIUFPc51MV66zYdwOPUno'},
      body: json.encode(reqBody)
    );
    final responseJson = json.decode(response.body);
    return [response.statusCode,responseJson];
  } 

  if (method == "GET"){
    final response = await http.get(
      apiUrl + url,
      headers: {'Content-type':'application/json',
      'Accept':'application/json',
      'Authorization': 'Bearer P342A8HtvavVuSDNKV2fMd9TZctxVLs8Cw2I2nfi6HlMIUFPc51MV66zYdwOPUno'},
    );
    final responseJson = json.decode(response.body);
    return responseJson;
  }

  if (method == "DELETE"){
    final response = await http.delete(
      apiUrl + url,
      headers: {'Content-type':'application/json',
      'Accept':'application/json',
      'Authorization': 'Bearer P342A8HtvavVuSDNKV2fMd9TZctxVLs8Cw2I2nfi6HlMIUFPc51MV66zYdwOPUno'},
    );
    final responseJson = json.decode(response.body);
    return responseJson;
  }

  if (method == "PUT"){
    final response = await http.put(
      apiUrl + url,
      headers: {'Content-type':'application/json',
      'Accept':'application/json',
      'Authorization': 'Bearer P342A8HtvavVuSDNKV2fMd9TZctxVLs8Cw2I2nfi6HlMIUFPc51MV66zYdwOPUno'},
      body: reqBody
    );
    final responseJson = json.decode(response.body);
    return responseJson;
  }

   //??
}
