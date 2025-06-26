import 'package:get/get.dart';

import '../controllers/biodata_tinggi_berat_controller.dart';

class BiodataTinggiBeratBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BiodataTinggiBeratController>(
      () => BiodataTinggiBeratController(),
    );
  }
}
