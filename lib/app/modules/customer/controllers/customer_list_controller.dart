import 'dart:convert';
import 'package:get/get.dart';
import '../../../data/providers/user_provider.dart';

class CustomerListController extends GetxController {
  final UserProvider _provider = UserProvider();

  var customers = [].obs;
  var filteredCustomers = [].obs;
  var isLoading = false.obs;
  var searchQuery = "".obs;

  // Pagination
  var currentPage = 1.obs;
  var totalCustomers = 0.obs;
  final int pageSize = 20;

  @override
  void onInit() {
    super.onInit();
    fetchCustomers();
    
    // Setup search listener
    debounce(searchQuery, (_) => _filterCustomers(), time: const Duration(milliseconds: 300));
  }

  Future<void> fetchCustomers() async {
    try {
      isLoading.value = true;
      final response = await _provider.getCustomers(page: currentPage.value, size: pageSize);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        customers.value = data['items'];
        totalCustomers.value = data['total'];
        _filterCustomers();
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load customers: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void nextPage() {
    if (currentPage.value * pageSize < totalCustomers.value) {
      currentPage.value++;
      fetchCustomers();
    }
  }

  void previousPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
      fetchCustomers();
    }
  }

  void _filterCustomers() {
    if (searchQuery.value.isEmpty) {
      filteredCustomers.value = customers;
    } else {
      final query = searchQuery.value.toLowerCase();
      filteredCustomers.value = customers.where((c) {
        final name = "${c['first_name']} ${c['last_name']}".toLowerCase();
        final email = (c['email'] ?? "").toString().toLowerCase();
        final phone = (c['phone_number'] ?? "").toString().toLowerCase();
        return name.contains(query) || email.contains(query) || phone.contains(query);
      }).toList();
    }
  }
}
