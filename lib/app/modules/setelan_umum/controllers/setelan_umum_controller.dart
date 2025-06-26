import 'package:get/get.dart';

class SetelanUmumController extends GetxController {
  var biarkanLayarMenyala = true.obs;

  void toggleLayar(bool value) {
    biarkanLayarMenyala.value = value;
  }
}
