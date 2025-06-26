import 'package:get/get.dart';

import '../controllers/biodata_jk_controller.dart';

class BiodataJkBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BiodataJKController>(() => BiodataJKController());
  }
}
