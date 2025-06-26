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
}
