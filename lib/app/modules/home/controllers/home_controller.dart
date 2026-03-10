import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeController extends GetxController {
  var selectedIndex = 0.obs;
  var selectedProduct = Rxn<dynamic>();
  var adminName = "Admin".obs;
  var adminRole = "Admin".obs;

  @override
  void onInit() {
    super.onInit();
    final storage = GetStorage();
    adminName.value = storage.read('admin_name') ?? "Admin User";
    adminRole.value = storage.read('admin_role') ?? "Admin";
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
