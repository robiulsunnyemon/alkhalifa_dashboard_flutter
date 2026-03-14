import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/slider_controller.dart';

class SliderManagementView extends GetView<SliderController> {
  const SliderManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<SliderController>()) {
      Get.put(SliderController());
    }
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Slider Management', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Color(0xFF00B14F)),
            onPressed: () => _showAddSliderDialog(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.sliders.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF00B14F)));
        }
        
        if (controller.sliders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image_not_supported_outlined, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text('No sliders found', style: TextStyle(color: Colors.grey[600], fontSize: 16)),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.sliders.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final slider = controller.sliders[index];
            return Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey[200]!),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        slider['image_url'],
                        width: 120,
                        height: 70,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 120,
                          height: 70,
                          color: Colors.grey[200],
                          child: const Icon(Icons.broken_image),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            slider['title'] ?? 'No Title',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            slider['link_url'] ?? 'No Link',
                            style: TextStyle(color: Colors.grey[600], fontSize: 13),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: slider['is_active'] ?? true,
                      activeColor: const Color(0xFF00B14F),
                      onChanged: (value) => controller.toggleStatus(slider['id'], slider['is_active']),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => _confirmDelete(context, slider['id']),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  void _showAddSliderDialog(BuildContext context) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(24),
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Add New Slider', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              Obx(() => Column(
              children: [
                if (controller.selectedImageBytes.value != null)
                  Container(
                    height: 150,
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: MemoryImage(controller.selectedImageBytes.value!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                InkWell(
                  onTap: controller.pickImage,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade50,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image, color: Colors.grey[600]),
                        const SizedBox(width: 8),
                        Text(
                          controller.selectedFileName.value ?? "Select Image",
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )),
            const SizedBox(height: 16),
            TextField(
              controller: controller.titleController,
              decoration: const InputDecoration(
                labelText: "Title (Optional)",
                prefixIcon: Icon(Icons.title),
                border: OutlineInputBorder(),
              ),
            ),
              const SizedBox(height: 16),
              TextField(
                controller: controller.linkUrlController,
                decoration: const InputDecoration(
                  labelText: 'Link URL (Optional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.open_in_new),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                  ),
                  const SizedBox(width: 16),
                    Obx(() => ElevatedButton(
                      onPressed: controller.isUploading.value ? null : () => controller.addSlider(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00B14F),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: controller.isUploading.value 
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text("Add Slider"),
                    )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, int id) {
    Get.defaultDialog(
      title: "Delete Slider",
      middleText: "Are you sure you want to delete this slider?",
      textConfirm: "Delete",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        controller.deleteSlider(id);
        Get.back();
      },
    );
  }
}
