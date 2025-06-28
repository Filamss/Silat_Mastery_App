import 'dart:convert';
import 'package:get/get.dart';
import 'package:silat_mastery_app_2/app/services/api_service.dart';
import 'package:silat_mastery_app_2/app/routes/app_pages.dart';

class BiodataJKController extends GetxController {
  var jenisKelamin = ''.obs;

  void pilihJenisKelamin(String value) {
    jenisKelamin.value = value;
  }

  Future<void> simpanJenisKelamin() async {
  try {
    final response = await ApiService.updateJenisKelamin(jenisKelamin.value);
    final body = jsonDecode(response.body);

    if (body["success"] == true) {
      Get.toNamed(Routes.BIODATA_UMUR);
    } else {
      Get.snackbar('Gagal', body["message"] ?? 'Gagal memperbarui data');
    }
  } catch (e) {
    Get.snackbar('Error', 'Terjadi kesalahan: $e');
  }
}

}
