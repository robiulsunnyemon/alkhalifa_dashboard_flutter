import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../data/providers/payment_provider.dart';

class PaymentsController extends GetxController {
  final PaymentProvider _provider = Get.put(PaymentProvider());
  
  var stats = <String, dynamic>{
    'total_revenue': 0.0,
    'offline_revenue': 0.0,
    'online_revenue': 0.0,
    'ssl_cost': 0.0
  }.obs;
  
  var transactions = <dynamic>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      isLoading.value = true;
      final statsRes = await _provider.getPaymentStats();
      if (statsRes.statusCode == 200) {
        stats.value = Map<String, dynamic>.from(statsRes.body);
      }
      
      final transRes = await _provider.getTransactions();
      if (transRes.statusCode == 200) {
        transactions.value = transRes.body;
      }
    } finally {
      isLoading.value = false;
    }
  }

  String formatCurrency(dynamic amount) {
    final formatter = NumberFormat.currency(symbol: '৳', decimalDigits: 2);
    return formatter.format(amount ?? 0.0);
  }
}
