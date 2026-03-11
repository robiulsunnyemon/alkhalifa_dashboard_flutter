import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class OrderProvider {
  static const String baseUrl = 'http://localhost:8001/orders';
  final storage = GetStorage();

  String get _token => storage.read('token') ?? '';

  Future<http.Response> getAllOrders() async {
    return await http.get(
      Uri.parse('$baseUrl/all'),
      headers: {
        'Authorization': 'Bearer $_token',
      },
    );
  }

  Future<http.Response> updateOrderStatus(int orderId, String status) async {
    return await http.put(
      Uri.parse('$baseUrl/$orderId/status'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: '"$status"', // status is a simple string for the status enum if passed as JSON body
    );
  }

  Future<http.Response> deleteOrder(int orderId) async {
    return await http.delete(
      Uri.parse('$baseUrl/$orderId'),
      headers: {
        'Authorization': 'Bearer $_token',
      },
    );
  }
}
