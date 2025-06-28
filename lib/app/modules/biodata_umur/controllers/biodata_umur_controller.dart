import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:silat_mastery_app_2/app/services/api_service.dart';
import 'package:silat_mastery_app_2/app/routes/app_pages.dart';

class BiodataUmurController extends GetxController {
  final usia = 10.obs;
  final scrollController = FixedExtentScrollController(
    initialItem: 1,
  ); 

  void setUmur(int index) {
    usia.value = index;
  }

  void simpanUmur() async {
    try {
      final res = await ApiService.updateUmur(usia.value);
      final body = jsonDecode(res.body);

      if (body["success"] == true) {
        Get.toNamed(Routes.BIODATA_TINGGI_BERAT); 
      } else {
        Get.snackbar('Gagal', body["message"] ?? "Terjadi kesalahan");
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal menyimpan umur: $e');
    }
  }
}
