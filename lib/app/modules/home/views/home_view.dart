import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../product/views/product_view.dart';
import '../controllers/home_controller.dart';
import '../../category/views/category_view.dart';
import '../../product/views/product_list_view.dart';
import '../../customer/views/customer_list_view.dart';
import '../../party_menu/views/party_menu_view.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 250,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              children: [
                const DrawerHeader(
                  child: Center(
                    child: Icon(Icons.restaurant_menu, size: 64, color: Color(0xFF00B14F)),
                  ),
                ),
                Obx(() => _buildSidebarItem(
                  Icons.home, 
                  "Home", 
                  0, 
                  () => controller.changeIndex(0)
                )),
                Obx(() => _buildSidebarItem(
                  Icons.category, 
                  "Category", 
                  1, 
                  () => controller.changeIndex(1)
                )),
                Obx(() => _buildSidebarItem(
                  Icons.group_outlined, 
                  "Customers", 
                  4, 
                  () => controller.changeIndex(4)
                )),
                Obx(() => _buildSidebarItem(
                  Icons.list, 
                  "Products", 
                  2, 
                  () => controller.changeIndex(2)
                )),
                Obx(() => _buildSidebarItem(
                  Icons.party_mode_outlined, 
                  "Party Menu", 
                  5, 
                  () => controller.changeIndex(5)
                )),
                const Spacer(),
                _buildSidebarItem(
                  Icons.logout, 
                  "Logout", 
                  -1, 
                  () => _showLogoutConfirm()
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          const VerticalDivider(width: 1),
          // Main Content Area
          Expanded(
            child: Obx(() {
              switch (controller.selectedIndex.value) {
                case 0:
                  return const Center(
                    child: Text(
                      'Welcome to Dashboard',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  );
                case 1:
                  return const CategoryView();
                case 2:
                  return const ProductListView();
                case 3:
                  return const ProductView();
                case 4:
                  return const CustomerListView();
                case 5:
                  return const PartyMenuView();
                default:
                  return const Center(child: Text("Page not found"));
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(IconData icon, String title, int index, VoidCallback onTap) {
    final isSelected = controller.selectedIndex.value == index;
    return ListTile(
      leading: Icon(
        icon, 
        color: isSelected ? const Color(0xFF00B14F) : Colors.grey[600]
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? const Color(0xFF00B14F) : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: const Color(0xFF00B14F).withOpacity(0.05),
      onTap: onTap,
    );
  }

  void _showLogoutConfirm() {
    Get.defaultDialog(
      title: "Logout",
      middleText: "Are you sure you want to logout?",
      textConfirm: "Yes",
      textCancel: "No",
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFF00B14F),
      onConfirm: () => Get.offAllNamed('/login'),
    );
  }
}
