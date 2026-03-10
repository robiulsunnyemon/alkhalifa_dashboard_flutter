import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../data/providers/category_provider.dart';
import 'dart:convert';

class CategoryController extends GetxController {
  final CategoryProvider _provider = CategoryProvider();

  var categories = <dynamic>[].obs;
  var isLoading = false.obs;
  var searchQuery = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  List<dynamic> get filteredCategories {
    if (searchQuery.value.isEmpty) {
      return categories;
    }
    return categories.where((cat) {
      return cat['name'].toString().toLowerCase().contains(searchQuery.value.toLowerCase());
    }).toList();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      final response = await _provider.getCategories();
      if (response.statusCode == 200) {
        categories.value = jsonDecode(response.body);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addCategory(String name) async {
    try {
      final response = await _provider.createCategory(name);
      if (response.statusCode == 201) {
        fetchCategories();
        Get.back();
        Get.snackbar("Success", "Category added successfully", backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        final error = jsonDecode(response.body);
        Get.snackbar("Error", error['detail'] ?? "Failed to add category", backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> updateCategory(int id, String name) async {
    try {
      final response = await _provider.updateCategory(id, name);
      if (response.statusCode == 200) {
        fetchCategories();
        Get.back();
        Get.snackbar("Success", "Category updated successfully", backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        final error = jsonDecode(response.body);
        Get.snackbar("Error", error['detail'] ?? "Failed to update category", backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> deleteCategory(int id) async {
    try {
      final response = await _provider.deleteCategory(id);
      if (response.statusCode == 204) {
        fetchCategories();
        Get.snackbar("Success", "Category deleted successfully", backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar("Error", "Failed to delete category", backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
