import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import '../../../data/providers/order_provider.dart';

class OrderManagementController extends GetxController {
  final OrderProvider _provider = OrderProvider();
  
  var orders = [].obs;
  var filteredOrders = [].obs;
  var isLoading = false.obs;
  var selectedStatus = "ALL".obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      isLoading.value = true;
      final response = await _provider.getAllOrders();
      if (response.statusCode == 200) {
        orders.value = jsonDecode(response.body);
        filterOrders(selectedStatus.value);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch orders', backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  void filterOrders(String status) {
    selectedStatus.value = status;
    if (status == "ALL") {
      filteredOrders.value = orders;
    } else {
      filteredOrders.value = orders.where((order) => order['status'] == status).toList();
    }
  }

  Future<void> updateStatus(int id, String status) async {
    try {
      isLoading.value = true;
      final response = await _provider.updateOrderStatus(id, status);
      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Order status updated to $status', backgroundColor: Colors.green, colorText: Colors.white);
        fetchOrders();
      } else {
        Get.snackbar('Error', 'Failed to update order status', backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteOrder(int id) async {
    Get.defaultDialog(
      title: "Confirm Delete",
      middleText: "Are you sure you want to delete this order?",
      textConfirm: "Delete",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        Get.back();
        try {
          isLoading.value = true;
          final response = await _provider.deleteOrder(id);
          if (response.statusCode == 200) {
            Get.snackbar('Success', 'Order deleted successfully', backgroundColor: Colors.green, colorText: Colors.white);
            fetchOrders();
          } else {
            Get.snackbar('Error', 'Failed to delete order', backgroundColor: Colors.red, colorText: Colors.white);
          }
        } finally {
          isLoading.value = false;
        }
      }
    );
  }
}
