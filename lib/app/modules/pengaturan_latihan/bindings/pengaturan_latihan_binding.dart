import 'package:get/get.dart';

import '../controllers/pengaturan_latihan_controller.dart';

class PengaturanLatihanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PengaturanLatihanController>(
      () => PengaturanLatihanController(),
    );
  }
}
