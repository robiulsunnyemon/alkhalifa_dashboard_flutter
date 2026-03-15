import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import '../api_constants.dart';

class SectionProvider {
  final _storage = GetStorage();

  String? get _token => _storage.read('token');

  Map<String, String> get _headers => {
        "Content-Type": "application/json",
        "Authorization": "Bearer $_token",
      };

  Future<http.Response> getHomeSections() async {
    return await http.get(Uri.parse('${ApiConstants.baseUrl}/product-sections/home'));
  }

  Future<http.Response> getAllSections() async {
    return await http.get(
      Uri.parse('${ApiConstants.baseUrl}/product-sections/'),
      headers: _headers,
    );
  }

  Future<http.Response> createSection(Map<String, dynamic> data) async {
    return await http.post(
      Uri.parse('${ApiConstants.baseUrl}/product-sections/'),
      headers: _headers,
      body: jsonEncode(data),
    );
  }

  Future<http.Response> updateSection(int id, Map<String, dynamic> data) async {
    return await http.put(
      Uri.parse('${ApiConstants.baseUrl}/product-sections/$id'),
      headers: _headers,
      body: jsonEncode(data),
    );
  }

  Future<http.Response> deleteSection(int id) async {
    return await http.delete(
      Uri.parse('${ApiConstants.baseUrl}/product-sections/$id'),
      headers: _headers,
    );
  }

  Future<http.Response> assignProduct(int sectionId, int productId, {int orderIndex = 0}) async {
    return await http.post(
      Uri.parse('${ApiConstants.baseUrl}/product-sections/$sectionId/assign/$productId?order_index=$orderIndex'),
      headers: _headers,
    );
  }

  Future<http.Response> removeProduct(int sectionId, int productId) async {
    return await http.delete(
      Uri.parse('${ApiConstants.baseUrl}/product-sections/$sectionId/remove/$productId'),
      headers: _headers,
    );
  }
}
