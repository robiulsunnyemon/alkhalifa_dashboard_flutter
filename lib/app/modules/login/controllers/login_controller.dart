import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';

import 'dart:convert';

import '../../../data/providers/dashboard_auth_provider.dart';

class LoginController extends GetxController {
  final DashboardAuthProvider _authProvider = DashboardAuthProvider();
  final GetStorage _storage = GetStorage();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  var isLoading = false.obs;

  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar("Error", "Please fill all fields", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;
      final response = await _authProvider.login(emailController.text, passwordController.text);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['access_token'];
        
        await _storage.write('token', token);
        await _storage.write('admin_name', "${data['user']['first_name']} ${data['user']['last_name']}");
        await _storage.write('admin_role', data['user']['role']);
        Get.offAllNamed('/home');
      } else {
        final error = jsonDecode(response.body);
        Get.snackbar("Login Failed", error['detail'] ?? "Unknown error", backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
