import 'package:get/get.dart';
import 'dart:async';
import 'package:get_storage/get_storage.dart';
import 'package:silat_mastery_app_2/app/routes/app_pages.dart';

class SplashController extends GetxController {
  final RxDouble opacity = 1.0.obs;
  final box = GetStorage();

  @override
  void onReady() {
    super.onReady();
    _startAnimationAndNavigation();
  }

  void _startAnimationAndNavigation() {
    Future.delayed(const Duration(milliseconds: 500), () {
      opacity.value = 0.0; // Trigger animasi fade-out
    });

    Timer(const Duration(seconds: 2), () {
      bool sudahLihatInfo = box.read('sudah_lihat_info') ?? false;

      if (sudahLihatInfo) {
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.offAllNamed(Routes.INFO);
      }
    });
  }
}
