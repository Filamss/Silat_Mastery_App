import 'package:get/get.dart';

import '../controllers/biodata_umur_controller.dart';

class BiodataUmurBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BiodataUmurController>(
      () => BiodataUmurController(),
    );
  }
}
