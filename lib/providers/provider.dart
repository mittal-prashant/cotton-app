import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

String baseUrl1 =
    "https://sde-007.api.assignment.theinternetfolks.works/v1/event";
String baseUrl = "https://7bd1-2a09-bac1-36c0-5bd0-00-1f1-1ef.ngrok-free.app";

Future<bool> checkTokenStatus() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("token")!;
  final response = await http.get(Uri.parse(baseUrl), headers: {
    'Content-type': 'application/json',
    'Authorization': 'Bearer $token'
  });
  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

Future<bool> registerUser(String username, String password) async {
  final response = await http.post(Uri.parse("$baseUrl/register"),
      headers: {'Content-type': 'application/json'},
      body: json.encode({"username": username, "password": password}));

  if (response.statusCode == 201) {
    return true;
  } else {
    return false;
  }
}

Future<bool> loginUser(String username, String password) async {
  final response = await http.post(Uri.parse("$baseUrl/login"),
      headers: {'Content-type': 'application/json'},
      body: json.encode({"username": username, "password": password}));

  if (response.statusCode == 200) {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("token", json.decode(response.body)["access_token"]);
    prefs.setBool("isLoggedIn", true);
    return true;
  } else {
    return false;
  }
}

Future<List> getImageDetails(File selectedImage) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("token")!;
  final Uri uri = Uri.parse("$baseUrl/upload");
  final request = http.MultipartRequest("POST", uri);
  final Map<String, String> headers = {
    "Authorization": 'Bearer $token',
    "Content-type": "multipart/form-data"
  };
  request.headers.addAll(headers);

  final fileStream = http.ByteStream(selectedImage.openRead());
  final fileLength = await selectedImage.length();
  final multipartFile = http.MultipartFile(
    'file',
    fileStream,
    fileLength,
    filename: selectedImage.path.split('/').last,
  );
  request.files.add(multipartFile);
  final response = await request.send();
  final res = await http.Response.fromStream(response);
  var length = json.decode(res.body)["length"];
  var width = json.decode(res.body)["width"];
  return [length, width];
}

Future<String> getDetails(int id) async {
  final response = await http.get(Uri.parse('$baseUrl1/$id'));

  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to fetch event details!');
  }
}

Future<String> getEvents() async {
  final response = await http.get(Uri.parse(baseUrl1));

  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to fetch events!');
  }
}
