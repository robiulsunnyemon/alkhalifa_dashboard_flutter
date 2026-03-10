import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../api_constants.dart';

class UserProvider {
  final _storage = GetStorage();

  String? get _token => _storage.read('token');

  Future<http.Response> getCustomers({int page = 1, int size = 20}) async {
    return await http.get(
      Uri.parse("${ApiConstants.customers}?page=$page&size=$size"),
      headers: {
        "Authorization": "Bearer $_token",
      },
    );
  }

  Future<http.Response> getMe() async {
    return await http.get(
      Uri.parse(ApiConstants.userMe),
      headers: {
        "Authorization": "Bearer $_token",
      },
    );
  }
}
