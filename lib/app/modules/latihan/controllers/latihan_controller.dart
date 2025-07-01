import 'package:get/get.dart';
import 'package:silat_mastery_app_2/app/services/api_service.dart';

class LatihanController extends GetxController {
  final daftarLatihan = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final dataLatihan = Rxn<Map<String, dynamic>>();
  final tipeModel = ''.obs;

  @override
  void onInit() {
    final arg = Get.arguments as Map<String, dynamic>?;
    if (arg != null && arg['id'] != null) {
      fetchLatihanById(arg['id']);
    }
    super.onInit();
  }

  void fetchLatihanById(String id) async {
    isLoading.value = true;

    final data = await ApiService.getLatihanById(id);

    if (data != null) {
      dataLatihan.value = data;

      // ✅ Ambil nama latihan
      final namaLatihan = (data['nama_latihan'] ?? '').toString().toLowerCase();

      // ✅ Deteksi tipe model dari nama_latihan
      if (namaLatihan.contains('tendangan')) {
        tipeModel.value = 'tendangan';
      } else if (namaLatihan.contains('tangkisan')) {
        tipeModel.value = 'tangkisan';
      } else if (namaLatihan.contains('pukulan')) {
        tipeModel.value = 'pukulan';
      } else {
        tipeModel.value = 'tidak diketahui';
      }

      daftarLatihan.value = List<Map<String, dynamic>>.from(data['gerakan'] ?? []);
    } else {
      daftarLatihan.clear();
      tipeModel.value = 'tidak diketahui';
    }

    isLoading.value = false;
  }
}
