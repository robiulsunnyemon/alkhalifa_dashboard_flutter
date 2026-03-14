import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../api_constants.dart';

class DashboardProvider {
  final _storage = GetStorage();

  String? get _token => _storage.read('token');

  Future<http.Response> getDashboardStats(String period) async {
    return await http.get(
      Uri.parse("${ApiConstants.dashboard}/stats?period=$period"),
      headers: {
        "Authorization": "Bearer $_token",
        "Accept": "application/json",
      },
    );
  }
}
