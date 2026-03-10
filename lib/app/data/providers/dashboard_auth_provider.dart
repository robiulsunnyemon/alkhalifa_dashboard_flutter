import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_constants.dart';

class DashboardAuthProvider {
  Future<http.Response> login(String emailOrPhone, String password) async {
    return await http.post(
      Uri.parse(ApiConstants.login),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email_or_phone": emailOrPhone,
        "password": password,
      }),
    );
  }
}
