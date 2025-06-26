import 'package:get/get.dart';
import 'package:silat_mastery_app_2/app/services/api_service.dart';

class LatihanController extends GetxController {
  final daftarLatihan = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final dataLatihan = Rxn<Map<String, dynamic>>();

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

    final data = await ApiService.getLatihanById(id); // 🔁 Ambil by ID
    if (data != null) {
      dataLatihan.value = data;
      daftarLatihan.value = List<Map<String, dynamic>>.from(data['gerakan'] ?? []);
    } else {
      daftarLatihan.clear();
    }

    isLoading.value = false;
  }
}
