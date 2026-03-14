import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../api_constants.dart';

class PaymentProvider extends GetConnect {
  final storage = GetStorage();

  @override
  void onInit() {
    httpClient.baseUrl = ApiConstants.payments;
    httpClient.addRequestModifier<dynamic>((request) {
      final token = storage.read('token');
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      return request;
    });
  }

  Future<Response> getPaymentStats() => get('/stats');
  
  Future<Response> getTransactions() => get('/transactions');
}
