import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/providers/cms_provider.dart';
import '../../../data/providers/user_provider.dart';


class SettingsController extends GetxController with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  final UserProvider _userProvider = UserProvider();
  final CmsProvider _cmsProvider = CmsProvider();

  // Profile Form Controls
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  // Password Form Controls
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var isLoading = false.obs;
  var isSavingPassword = false.obs;
  
  // CMS Pages State
  var cmsPages = <String, dynamic>{}.obs; // slug -> content
  var isLoadingCms = false.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    fetchAdminProfile();
    fetchCmsPages();
  }

  Future<void> fetchAdminProfile() async {
    try {
      final response = await _userProvider.getMe();
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        firstNameController.text = data['first_name'] ?? '';
        lastNameController.text = data['last_name'] ?? '';
        emailController.text = data['email'] ?? '';
        phoneController.text = data['phone_number'] ?? '';
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch profile: $e");
    }
  }

  Future<void> updateProfile() async {
    try {
      isLoading.value = true;
      final response = await _userProvider.updateProfile({
        "first_name": firstNameController.text,
        "last_name": lastNameController.text,
        "email": emailController.text,
        "phone_number": phoneController.text,
      });
      if (response.statusCode == 200) {
        Get.snackbar("Success", "Profile updated successfully", backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar("Error", jsonDecode(response.body)['detail'] ?? "Update failed", backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Connection error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changePassword() async {
    if (newPasswordController.text != confirmPasswordController.text) {
      Get.snackbar("Error", "New passwords do not match", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    try {
      isSavingPassword.value = true;
      final response = await _userProvider.changePassword(
        oldPasswordController.text,
        newPasswordController.text,
        confirmPasswordController.text,
      );
      if (response.statusCode == 200) {
        Get.snackbar("Success", "Password changed successfully", backgroundColor: Colors.green, colorText: Colors.white);
        oldPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();
      } else {
        Get.snackbar("Error", jsonDecode(response.body)['detail'] ?? "Change failed", backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Connection error: $e");
    } finally {
      isSavingPassword.value = false;
    }
  }

  Future<void> fetchCmsPages() async {
    isLoadingCms.value = true;
    try {
      final slugs = ['about-us', 'privacy-policy', 'terms-conditions'];
      for (var slug in slugs) {
        final res = await _cmsProvider.getPage(slug);
        if (res.statusCode == 200) {
          cmsPages[slug] = jsonDecode(res.body);
        }
      }
    } catch (e) {
      print("CMS Error: $e");
    } finally {
      isLoadingCms.value = false;
    }
  }

  Future<void> saveCmsPage(String slug, String content) async {
    try {
      final response = await _cmsProvider.updatePage(slug, content);
      if (response.statusCode == 200) {
        cmsPages[slug] = jsonDecode(response.body);
        Get.snackbar("Success", "${slug.replaceAll('-', ' ').capitalizeFirst} updated", backgroundColor: Colors.green, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to save: $e");
    }
  }

  @override
  void onClose() {
    tabController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
