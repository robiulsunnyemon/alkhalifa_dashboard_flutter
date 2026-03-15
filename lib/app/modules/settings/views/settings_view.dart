import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: controller.tabController,
          labelColor: const Color(0xFF00B14F),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF00B14F),
          tabs: const [
            Tab(text: "Account"),
            Tab(text: "Pages"),
          ],
        ),
      ),
      body: TabBarView(
        controller: controller.tabController,
        children: [
          _buildAccountTab(),
          _buildPagesTab(),
        ],
      ),
    );
  }

  Widget _buildAccountTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Personal Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildTextField("First Name", controller.firstNameController)),
              const SizedBox(width: 16),
              Expanded(child: _buildTextField("Last Name", controller.lastNameController)),
            ],
          ),
          const SizedBox(height: 16),
          _buildTextField("Email", controller.emailController),
          const SizedBox(height: 16),
          _buildTextField("Phone Number", controller.phoneController),
          const SizedBox(height: 24),
          Obx(() => ElevatedButton(
            onPressed: controller.isLoading.value ? null : controller.updateProfile,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF007E33),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: controller.isLoading.value ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text("Save Changes"),
          )),
          const Divider(height: 48),
          const Text("Security & Password", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          _buildTextField("Old Password", controller.oldPasswordController, isPassword: true),
          const SizedBox(height: 16),
          _buildTextField("New Password", controller.newPasswordController, isPassword: true),
          const SizedBox(height: 16),
          _buildTextField("Confirm New Password", controller.confirmPasswordController, isPassword: true),
          const SizedBox(height: 24),
          Obx(() => ElevatedButton(
            onPressed: controller.isSavingPassword.value ? null : controller.changePassword,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF007E33),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: controller.isSavingPassword.value ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text("Update Password"),
          )),
        ],
      ),
    );
  }

  Widget _buildPagesTab() {
    return Obx(() {
      if (controller.isLoadingCms.value) {
        return const Center(child: CircularProgressIndicator());
      }
      return ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildPageItem("About Us", 'about-us'),
          _buildPageItem("Privacy & Policy", 'privacy-policy'),
          _buildPageItem("Terms & Condition", 'terms-conditions'),
        ],
      );
    });
  }

  Widget _buildPageItem(String title, String slug) {
    return Card(
      color: Colors.white,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        title: Text(title),
        trailing: const Icon(Icons.edit, color: Colors.green),
        onTap: () => _showEditPageDialog(title, slug),
      ),
    );
  }

  void _showEditPageDialog(String title, String slug) {
    final contentController = TextEditingController(text: controller.cmsPages[slug]?['content'] ?? '');
    Get.dialog(
      Dialog(
        child: Container(
          width: 800,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Edit $title", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextField(
                controller: contentController,
                maxLines: 15,
                decoration: InputDecoration(
                  hintText: "Enter $title content here...",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      controller.saveCmsPage(slug, contentController.text);
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                    child: const Text("Save"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController textController, {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 8),
        TextField(
          controller: textController,
          obscureText: isPassword,
          decoration: InputDecoration(
            isDense: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
        ),
      ],
    );
  }
}
