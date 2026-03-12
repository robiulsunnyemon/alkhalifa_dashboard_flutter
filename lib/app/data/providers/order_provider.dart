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
      Uri.parse('$baseUrl/$orderId/status?status=$status'),
      headers: {
        'Authorization': 'Bearer $_token',
      },
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
