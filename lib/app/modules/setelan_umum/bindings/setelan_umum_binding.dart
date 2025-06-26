import 'package:get/get.dart';

import '../controllers/setelan_umum_controller.dart';

class SetelanUmumBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SetelanUmumController>(
      () => SetelanUmumController(),
    );
  }
}
