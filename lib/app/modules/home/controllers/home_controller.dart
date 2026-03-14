import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import '../../../data/providers/dashboard_provider.dart';

class HomeController extends GetxController {
  var selectedIndex = 0.obs;
  var selectedProduct = Rxn<dynamic>();
  var adminName = "Admin".obs;
  var adminRole = "Admin".obs;

  // Dashboard Stats
  var period = "week".obs;
  var activeListings = 0.obs;
  var activeMenus = 0.obs;
  var pendingOrders = 0.obs;
  var totalRevenue = 0.0.obs;
  var revenueChart = <Map<String, dynamic>>[].obs;
  var userGrowthChart = <Map<String, dynamic>>[].obs;
  var isLoadingStats = false.obs;
  var statsError = "".obs;

  final DashboardProvider _dashboardProvider = DashboardProvider();

  @override
  void onInit() {
    super.onInit();
    final storage = GetStorage();
    adminName.value = storage.read('admin_name') ?? "Admin User";
    adminRole.value = storage.read('admin_role') ?? "Admin";

    // Fetch stats on init
    fetchDashboardStats();
  }

  Future<void> fetchDashboardStats() async {
    isLoadingStats.value = true;
    statsError.value = "";
    try {
      final response = await _dashboardProvider.getDashboardStats(period.value);

      print("Dashboard Stats statuscode: ${response.statusCode}");

      if (response.statusCode != 200) {
        statsError.value = "Failed to load stats: ${response.reasonPhrase} (${response.statusCode})";
      } else {
        final data = jsonDecode(response.body);
        
        if (data is! Map) {
          statsError.value = "Unexpected response format. Please check if your API is deployed correctly.";
          return;
        }

        final Map<String, dynamic> statsData = Map<String, dynamic>.from(data);
        
        // Robust parsing to handle cases where API might return strings or different types
        activeListings.value = _parseToInt(statsData['active_listings']);
        activeMenus.value = _parseToInt(statsData['active_menus']);
        pendingOrders.value = _parseToInt(statsData['pending_orders']);
        totalRevenue.value = _parseToDouble(statsData['total_revenue']);

        revenueChart.value = (statsData['revenue_chart'] as List? ?? []).map((e) => {
          'label': e['label']?.toString() ?? '',
          'value': _parseToDouble(e['value'])
        }).toList();

        userGrowthChart.value = (statsData['user_growth_chart'] as List? ?? []).map((e) => {
          'label': e['label']?.toString() ?? '',
          'value': _parseToDouble(e['value'])
        }).toList();
      }
    } catch (e) {
      statsError.value = "An error occurred during parsing: $e";
    } finally {
      isLoadingStats.value = false;
    }
  }

  int _parseToInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  double _parseToDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  void updatePeriod(String newPeriod) {
    if (period.value != newPeriod) {
      period.value = newPeriod;
      fetchDashboardStats();
    }
  }

  void changeIndex(int index, {dynamic argument}) {
    selectedIndex.value = index;
    if (argument != null) {
      selectedProduct.value = argument;
    } else {
      selectedProduct.value = null;
    }
  }
}
