import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../api_constants.dart';

class CmsProvider {
  final _storage = GetStorage();

  String? get _token => _storage.read('token');

  Future<http.Response> getPage(String slug) async {
    return await http.get(
      Uri.parse("${ApiConstants.cms}/$slug"),
      headers: {
        "Authorization": "Bearer $_token",
      },
    );
  }

  Future<http.Response> updatePage(String slug, String content) async {
    return await http.put(
      Uri.parse("${ApiConstants.cms}/$slug"),
      headers: {
        "Authorization": "Bearer $_token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "content": content,
      }),
    );
  }
}
