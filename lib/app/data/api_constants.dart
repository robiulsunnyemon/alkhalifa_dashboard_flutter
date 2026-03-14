class ApiConstants {
  // static const String baseUrl = "http://10.0.2.2:8000"; // For Android Emulator
  static const String baseUrl = "https://akfoodapi.maktechlaravel.cloud"; // For Web/Desktop
  
  static const String login = "$baseUrl/auth/login";
  static const String categories = "$baseUrl/categories/";
  static const String products = "$baseUrl/products/";
  static const String userMe = "$baseUrl/user/me";
  static const String customers = "$baseUrl/user/customers";
  static const String partyMenu = "$baseUrl/party-menu";
  static const String deliveryAreas = "$baseUrl/delivery-areas/";
  static const String deliveryFee = "$baseUrl/delivery-fee/";
  static const String orders = "$baseUrl/orders";
  static const String payments = "$baseUrl/payments";
  static const String dashboard = "$baseUrl/dashboard";
}
