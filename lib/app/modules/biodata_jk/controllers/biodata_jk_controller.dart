import 'package:get/get.dart';
import 'package:silat_mastery_app_2/app/services/api_service.dart';
import 'package:silat_mastery_app_2/app/routes/app_pages.dart';

class BiodataJKController extends GetxController {
  var jenisKelamin = ''.obs;

  void pilihJenisKelamin(String value) {
    jenisKelamin.value = value;
  }

  Future<void> simpanJenisKelamin() async {
    if (jenisKelamin.isEmpty) {
      Get.snackbar('Peringatan', 'Silakan pilih jenis kelamin terlebih dahulu');
      return;
    }

    try {
      await ApiService.updateJenisKelamin(jenisKelamin.value);
      Get.offAllNamed(Routes.BIODATA_UMUR); // Ganti ke langkah berikut jika ada
    } catch (e) {
      Get.snackbar('Error', 'Gagal menyimpan data: $e');
    }
  }
}
