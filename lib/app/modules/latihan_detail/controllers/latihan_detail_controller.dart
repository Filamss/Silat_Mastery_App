import 'package:get/get.dart';

class LatihanDetailController extends GetxController {
  final gerakan = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    final data = Get.arguments;
    if (data != null && data is Map<String, dynamic>) {
      gerakan.assignAll(data);
    } else {
      Get.snackbar('Error', 'Data gerakan tidak valid');
    }
  }

  void tambahRepetisi() {
    gerakan.update('repetisi', (val) => val + 1);
  }

  void kurangRepetisi() {
    if ((gerakan['repetisi'] ?? 0) > 1) {
      gerakan.update('repetisi', (val) => val - 1);
    }
  }

  void tambahDurasi() {
    gerakan.update('durasi', (val) => val + 5);
  }

  void kurangDurasi() {
    if ((gerakan['durasi'] ?? 0) > 1) {
      gerakan.update('durasi', (val) => val - 5);
    }
  }
}
