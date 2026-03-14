import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import '../../../data/providers/slider_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';

class SliderController extends GetxController {
  final SliderProvider _provider = SliderProvider();
  
  var sliders = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var isUploading = false.obs;
  
  var selectedImageBytes = Rxn<Uint8List>();
  var selectedFileName = RxnString();
  
  final titleController = TextEditingController();
  final linkUrlController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchSliders();
  }

  Future<void> pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      selectedImageBytes.value = result.files.first.bytes;
      selectedFileName.value = result.files.first.name;
    }
  }

  Future<void> fetchSliders() async {
    try {
      isLoading.value = true;
      final response = await _provider.getAllSliders();
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        sliders.value = List<Map<String, dynamic>>.from(data);
      } else {
        Get.snackbar("Error", "Failed to fetch sliders", backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addSlider() async {
    if (selectedImageBytes.value == null) {
      Get.snackbar("Error", "Please select an image", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      isUploading.value = true;
      final response = await _provider.createSlider(
        title: titleController.text.isEmpty ? null : titleController.text,
        linkUrl: linkUrlController.text.isEmpty ? null : linkUrlController.text,
        imageBytes: selectedImageBytes.value!,
        fileName: selectedFileName.value!,
      );

      if (response.statusCode == 200) {
        Get.back(); // Close dialog
        titleController.clear();
        linkUrlController.clear();
        selectedImageBytes.value = null;
        selectedFileName.value = null;
        fetchSliders();
        Get.snackbar("Success", "Slider added successfully", backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        final body = await response.stream.bytesToString();
        Get.snackbar("Error", "Failed to add slider: $body", backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isUploading.value = false;
    }
  }

  Future<void> toggleStatus(int id, bool currentStatus) async {
    try {
      final response = await _provider.updateSlider(id, {"is_active": !currentStatus});
      if (response.statusCode == 200) {
        fetchSliders();
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> deleteSlider(int id) async {
    try {
      final response = await _provider.deleteSlider(id);
      if (response.statusCode == 200) {
        fetchSliders();
        Get.snackbar("Success", "Slider deleted successfully", backgroundColor: Colors.green, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    linkUrlController.dispose();
    super.onClose();
  }
}
