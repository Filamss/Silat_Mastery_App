import 'package:get/get.dart';

import '../controllers/latihan_v2_controller.dart';

class LatihanV2Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LatihanV2Controller>(
      () => LatihanV2Controller(),
    );
  }
}
