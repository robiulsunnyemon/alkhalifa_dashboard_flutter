import 'dart:convert';
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

  Future<http.Response> updateProfile(Map<String, dynamic> data) async {
    return await http.put(
      Uri.parse(ApiConstants.updateProfile),
      headers: {
        "Authorization": "Bearer $_token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(data),
    );
  }

  Future<http.Response> changePassword(String oldPassword, String newPassword, String confirmPassword) async {
    return await http.put(
      Uri.parse(ApiConstants.changePassword),
      headers: {
        "Authorization": "Bearer $_token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "old_password": oldPassword,
        "new_password": newPassword,
        "confirm_new_password": confirmPassword,
      }),
    );
  }
}
