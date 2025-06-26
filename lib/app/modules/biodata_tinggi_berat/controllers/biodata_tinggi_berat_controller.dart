import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:silat_mastery_app_2/app/services/api_service.dart';
import 'package:silat_mastery_app_2/app/routes/app_pages.dart';

class BiodataTinggiBeratController extends GetxController {
  final tinggi = 170.obs;
  final berat = 60.0.obs;

  final tinggiController = FixedExtentScrollController(
    initialItem: 70,
  ); // 170cm

  void setTinggi(int val) => tinggi.value = val;
  void setBerat(double val) => berat.value = val;

  Future<void> simpanTinggiBerat() async {
    final box = GetStorage();
    final email = box.read('email');

    if (email == null) {
      Get.snackbar('Error', 'Email tidak ditemukan');
      return;
    }

    try {
      await ApiService.updateTinggi(tinggi.value);
      await ApiService.updateBerat(berat.value);
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      Get.snackbar('Error', 'Gagal menyimpan data: $e');
    }
  }
}
