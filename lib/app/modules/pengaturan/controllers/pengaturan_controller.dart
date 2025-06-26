import 'package:get/get.dart';

class PengaturanController extends GetxController {
  var syncHealth = false.obs;

  void toggleHealthSync(bool value) {
    syncHealth.value = value;
  }
}
