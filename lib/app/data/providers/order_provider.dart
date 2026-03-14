import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import '../api_constants.dart';

class OrderProvider {
  final storage = GetStorage();

  String get _token => storage.read('token') ?? '';

  Future<http.Response> getAllOrders() async {
    return await http.get(
      Uri.parse('${ApiConstants.orders}/all'),
      headers: {
        'Authorization': 'Bearer $_token',
      },
    );
  }

  Future<http.Response> updateOrderStatus(int orderId, String status) async {
    return await http.put(
      Uri.parse('${ApiConstants.orders}/$orderId/status?status=$status'),
      headers: {
        'Authorization': 'Bearer $_token',
      },
    );
  }

  Future<http.Response> deleteOrder(int orderId) async {
    return await http.delete(
      Uri.parse('${ApiConstants.orders}/$orderId'),
      headers: {
        'Authorization': 'Bearer $_token',
      },
    );
  }
}
