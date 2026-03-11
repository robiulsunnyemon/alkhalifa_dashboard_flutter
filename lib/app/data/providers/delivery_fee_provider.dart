import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../api_constants.dart';

class DeliveryFeeProvider {
  final _storage = GetStorage();

  String? get _token => _storage.read('token');

  Future<http.Response> getDeliveryFees() async {
    return await http.get(Uri.parse(ApiConstants.deliveryFee));
  }

  Future<http.Response> createDeliveryFee(Map<String, dynamic> data) async {
    return await http.post(
      Uri.parse(ApiConstants.deliveryFee),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $_token",
      },
      body: jsonEncode(data),
    );
  }

  Future<http.Response> updateDeliveryFee(int id, Map<String, dynamic> data) async {
    return await http.put(
      Uri.parse("${ApiConstants.deliveryFee}/$id"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $_token",
      },
      body: jsonEncode(data),
    );
  }

  Future<http.Response> deleteDeliveryFee(int id) async {
    return await http.delete(
      Uri.parse("${ApiConstants.deliveryFee}/$id"),
      headers: {
        "Authorization": "Bearer $_token",
      },
    );
  }
}
