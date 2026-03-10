import 'package:get/get.dart';
import '../controllers/product_list_controller.dart';
import '../controllers/product_controller.dart';

class ProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductListController>(() => ProductListController());
    Get.lazyPut<ProductController>(() => ProductController());
  }
}
