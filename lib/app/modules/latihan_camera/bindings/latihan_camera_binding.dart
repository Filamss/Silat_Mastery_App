import 'package:get/get.dart';

import '../controllers/latihan_camera_controller.dart';

class LatihanCameraBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LatihanCameraController>(
      () => LatihanCameraController(),
    );
  }
}
