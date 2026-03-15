import 'package:get/get.dart';
import '../controllers/section_management_controller.dart';

class SectionManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SectionManagementController>(
      () => SectionManagementController(),
    );
  }
}
