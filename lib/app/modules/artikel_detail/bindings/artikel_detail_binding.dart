import 'package:get/get.dart';

import '../controllers/artikel_detail_controller.dart';

class ArtikelDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ArtikelDetailController>(
      () => ArtikelDetailController(),
    );
  }
}
