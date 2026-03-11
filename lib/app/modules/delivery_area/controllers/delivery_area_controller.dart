import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import '../../../data/providers/delivery_area_provider.dart';
import 'package:http/http.dart' as http;

class DeliveryAreaController extends GetxController {
  final DeliveryAreaProvider _provider = DeliveryAreaProvider();
  
  var deliveryAreas = [].obs;
  var isLoading = false.obs;

  final cityController = TextEditingController();
  final locationsController = TextEditingController(); // comma separated

  @override
  void onInit() {
    super.onInit();
    fetchDeliveryAreas();
  }

  Future<void> fetchDeliveryAreas() async {
    try {
      isLoading.value = true;
      final response = await _provider.getDeliveryAreas();
      if (response.statusCode == 200) {
        deliveryAreas.value = jsonDecode(response.body);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch delivery areas', backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  void openFormDialog({Map<String, dynamic>? area}) {
    bool isEdit = area != null;
    
    if (isEdit) {
      cityController.text = area['city'];
      List locations = area['locations'];
      locationsController.text = locations.join(', ');
    } else {
      cityController.clear();
      locationsController.clear();
    }

    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        title: Text(isEdit ? "Edit Delivery Area" : "Add Delivery Area"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: cityController,
                decoration: const InputDecoration(labelText: 'City'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: locationsController,
                decoration: const InputDecoration(
                  labelText: 'Locations (comma separated)',
                  hintText: 'e.g. Area 1, Area 2',
                ),
                maxLines: 3,
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
              await _saveDeliveryArea(id: isEdit ? area['id'] : null);
            },
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      )
    );
  }

  Future<void> _saveDeliveryArea({int? id}) async {
    if (cityController.text.isEmpty) {
       Get.snackbar('Error', 'City is required', backgroundColor: Colors.red, colorText: Colors.white);
       return;
    }

    try {
      isLoading.value = true;
      List<String> locations = locationsController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      Map<String, dynamic> data = {
        "city": cityController.text,
        "locations": locations
      };

      http.Response response;
      if (id != null) {
        response = await _provider.updateDeliveryArea(id, data);
      } else {
        response = await _provider.createDeliveryArea(data);
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', id != null ? 'Area updated' : 'Area created', backgroundColor: Colors.green, colorText: Colors.white);
        fetchDeliveryAreas();
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

  Future<void> deleteDeliveryArea(int id) async {
    Get.defaultDialog(
      title: "Confirm Delete",
      middleText: "Are you sure you want to delete this delivery area?",
      textConfirm: "Delete",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        Get.back();
        try {
          isLoading.value = true;
          final response = await _provider.deleteDeliveryArea(id);
          if (response.statusCode == 200 || response.statusCode == 204) {
            Get.snackbar('Success', 'Area deleted successfully', backgroundColor: Colors.green, colorText: Colors.white);
            fetchDeliveryAreas();
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
