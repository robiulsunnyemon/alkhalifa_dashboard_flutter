import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../api_constants.dart';

class DeliveryAreaProvider {
  final _storage = GetStorage();

  String? get _token => _storage.read('token');

  Future<http.Response> getDeliveryAreas() async {
    return await http.get(Uri.parse(ApiConstants.deliveryAreas));
  }

  Future<http.Response> createDeliveryArea(Map<String, dynamic> data) async {
    return await http.post(
      Uri.parse(ApiConstants.deliveryAreas),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $_token",
      },
      body: jsonEncode(data),
    );
  }

  Future<http.Response> updateDeliveryArea(int id, Map<String, dynamic> data) async {
    return await http.put(
      Uri.parse("${ApiConstants.deliveryAreas}/$id"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $_token",
      },
      body: jsonEncode(data),
    );
  }

  Future<http.Response> deleteDeliveryArea(int id) async {
    return await http.delete(
      Uri.parse("${ApiConstants.deliveryAreas}/$id"),
      headers: {
        "Authorization": "Bearer $_token",
      },
    );
  }
}
