import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../api_constants.dart';

class ProductProvider {
  final _storage = GetStorage();

  String? get _token => _storage.read('token');

  Future<http.Response> getProducts({int page = 1, int size = 21}) async {
    return await http.get(Uri.parse("${ApiConstants.products}?page=$page&size=$size"));
  }

  Future<http.Response> createProduct(Map<String, dynamic> productData) async {
    return await http.post(
      Uri.parse(ApiConstants.products),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $_token",
      },
      body: jsonEncode(productData),
    );
  }

  Future<http.Response> updateProduct(int id, Map<String, dynamic> productData) async {
    return await http.put(
      Uri.parse("${ApiConstants.products}$id"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $_token",
      },
      body: jsonEncode(productData),
    );
  }

  Future<http.Response> deleteProduct(int id) async {
    return await http.delete(
      Uri.parse("${ApiConstants.products}$id"),
      headers: {
        "Authorization": "Bearer $_token",
      },
    );
  }
}
