import 'package:get/get.dart';

import '../controllers/latihan_v1_controller.dart';

class LatihanV1Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LatihanV1Controller>(
      () => LatihanV1Controller(),
    );
  }
}
