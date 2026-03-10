class ApiConstants {
  // static const String baseUrl = "http://10.0.2.2:8000"; // For Android Emulator
  static const String baseUrl = "http://127.0.0.1:8001"; // For Web/Desktop
  
  static const String login = "$baseUrl/auth/login";
  static const String categories = "$baseUrl/categories";
  static const String products = "$baseUrl/products";
  static const String userMe = "$baseUrl/user/me";
  static const String customers = "$baseUrl/user/customers";
}
