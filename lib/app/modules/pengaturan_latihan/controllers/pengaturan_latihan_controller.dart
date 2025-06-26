import 'package:get/get.dart';

class PengaturanLatihanController extends GetxController {
  var durasiRehat = 25.obs;
  var hitungMundur = 15.obs;

  void setDurasiRehat(int value) => durasiRehat.value = value;
  void setHitungMundur(int value) => hitungMundur.value = value;
}
