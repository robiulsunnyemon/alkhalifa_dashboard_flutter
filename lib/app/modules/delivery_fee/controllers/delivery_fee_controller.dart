import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import '../../../data/providers/delivery_fee_provider.dart';
import 'package:http/http.dart' as http;

class DeliveryFeeController extends GetxController {
  final DeliveryFeeProvider _provider = DeliveryFeeProvider();
  
  var deliveryFees = [].obs;
  var isLoading = false.obs;

  final feeController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchDeliveryFees();
  }

  Future<void> fetchDeliveryFees() async {
    try {
      isLoading.value = true;
      final response = await _provider.getDeliveryFees();
      if (response.statusCode == 200) {
        deliveryFees.value = jsonDecode(response.body);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch delivery fees', backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  void openFormDialog({Map<String, dynamic>? feeMap}) {
    // If no feeMap is provided but a fee already exists, use the first one
    if (feeMap == null && deliveryFees.isNotEmpty) {
      feeMap = deliveryFees.first;
    }

    bool isEdit = feeMap != null;
    
    if (isEdit) {
      feeController.text = feeMap['fee'].toString();
    } else {
      feeController.clear();
    }

    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        title: Text(isEdit ? "Edit Delivery Fee" : "Add Delivery Fee"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: feeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Delivery Fee Amount',
                  prefixText: '৳ ',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00B14F)),
            onPressed: () async {
              Get.back();
              await _saveDeliveryFee(id: isEdit ? feeMap!['id'] : null);
            },
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      )
    );
  }

  Future<void> _saveDeliveryFee({int? id}) async {
    if (feeController.text.isEmpty) {
       Get.snackbar('Error', 'Fee amount is required', backgroundColor: Colors.red, colorText: Colors.white);
       return;
    }

    try {
      isLoading.value = true;
      double feeAmount = double.tryParse(feeController.text) ?? 0.0;
      Map<String, dynamic> data = {
        "fee": feeAmount,
      };

      http.Response response;
      if (id != null) {
        response = await _provider.updateDeliveryFee(id, data);
      } else {
        response = await _provider.createDeliveryFee(data);
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'Delivery fee saved successfully', backgroundColor: Colors.green, colorText: Colors.white);
        fetchDeliveryFees();
      } else {
        var err = jsonDecode(response.body);
        Get.snackbar('Error', err['detail'] ?? 'Operation failed', backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch(e) {
      Get.snackbar('Error', e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteDeliveryFee(int id) async {
    Get.defaultDialog(
      title: "Confirm Delete",
      middleText: "Are you sure you want to delete this delivery fee?",
      textConfirm: "Delete",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        Get.back();
        try {
          isLoading.value = true;
          final response = await _provider.deleteDeliveryFee(id);
          if (response.statusCode == 200 || response.statusCode == 204) {
            Get.snackbar('Success', 'Fee deleted successfully', backgroundColor: Colors.green, colorText: Colors.white);
            fetchDeliveryFees();
          } else {
            var err = jsonDecode(response.body);
            Get.snackbar('Error', err['detail'] ?? 'Delete failed', backgroundColor: Colors.red, colorText: Colors.white);
          }
        } finally {
          isLoading.value = false;
        }
      }
    );
  }
}
