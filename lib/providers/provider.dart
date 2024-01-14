import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

String baseUrl =
    "https://sde-007.api.assignment.theinternetfolks.works/v1/event";

Future<String> getEvents() async {
  final response = await http.get(Uri.parse(baseUrl));

  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to fetch events!');
  }
}

Future<String> searchEvents(String searchText) async {
  final response = await http
      .get(Uri.parse(baseUrl).replace(queryParameters: {'search': searchText}));

  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to search events!');
  }
}

Future<String> getDetails(int id) async {
  final response = await http.get(Uri.parse('$baseUrl/$id'));

  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to fetch event details!');
  }
}

Future<bool> saveImage(List<int> imageBytes) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String base64Image = base64Encode(imageBytes);
  return prefs.setString("image", base64Image);
}

Future<Image> getImage() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  Uint8List bytes = base64Decode(prefs.getString("image")!);
  return Image.memory(bytes);
}
