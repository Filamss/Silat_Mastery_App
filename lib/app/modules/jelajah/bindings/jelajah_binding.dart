import 'package:get/get.dart';

import '../controllers/jelajah_controller.dart';

class JelajahBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JelajahController>(
      () => JelajahController(),
    );
  }
}
