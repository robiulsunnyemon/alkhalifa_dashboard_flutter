import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import '../api_constants.dart';

class CategoryProvider {
  final _storage = GetStorage();

  String? get _token => _storage.read('token');

  Future<http.Response> getCategories() async {
    return await http.get(Uri.parse(ApiConstants.categories));
  }

  Future<http.Response> createCategory(String name) async {
    return await http.post(
      Uri.parse(ApiConstants.categories),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $_token",
      },
      body: jsonEncode({"name": name}),
    );
  }

  Future<http.Response> updateCategory(int id, String name) async {
    return await http.put(
      Uri.parse("${ApiConstants.categories}/$id"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $_token",
      },
      body: jsonEncode({"name": name}),
    );
  }

  Future<http.Response> deleteCategory(int id) async {
    return await http.delete(
      Uri.parse("${ApiConstants.categories}/$id"),
      headers: {
        "Authorization": "Bearer $_token",
      },
    );
  }
}
