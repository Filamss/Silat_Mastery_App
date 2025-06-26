import 'dart:async';
import 'package:get/get.dart';

class LatihanV2Controller extends GetxController {
  final gerakan = <String, dynamic>{}.obs;
  final timerValue = 0.obs;
  final isRunning = true.obs;
  Timer? timer;
  final indexGerakan = 0.obs;

  List<Map<String, dynamic>> daftarLatihan = [];

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null) {
      loadData(args);
    }
  }

  void loadData(Map<String, dynamic>? args) {
    print("🔍 args masuk ke loadData: $args");

    if (args == null) {
      Get.snackbar('Error', 'Data tidak ditemukan');
      return;
    }

    final newIndex = args['index'] ?? 0;

    try {
      // ✔️ Validasi dan casting aman
      final rawGerakan = args['gerakan'];
      if (rawGerakan is Map) {
        final mappedGerakan = Map<String, dynamic>.from(rawGerakan);
        gerakan.assignAll(mappedGerakan);
        print("✅ Gerakan berhasil assign: $gerakan");
      } else {
        print("❌ Format gerakan tidak valid: $rawGerakan");
        Get.snackbar('Error', 'Data gerakan tidak valid');
        return;
      }

      final rawDaftar = args['daftarLatihan'];
      if (rawDaftar is List) {
        daftarLatihan = List<Map<String, dynamic>>.from(rawDaftar);
      }

      indexGerakan.value = newIndex;

      final durasi = gerakan['durasi'] ?? 0;
      if (durasi > 0) {
        timerValue.value = durasi;
        startTimer();
      } else {
        timer?.cancel();
        isRunning.value = false;
      }
    } catch (e) {
      print("❌ Error saat loadData: $e");
      Get.snackbar('Error', 'Gagal memuat data gerakan');
    }
  }

  bool sudahNavigasi = false;

void startTimer() {
  timer?.cancel();
  isRunning.value = true;

  timer = Timer.periodic(const Duration(seconds: 1), (t) {
    if (timerValue.value <= 1) {
      t.cancel();
      isRunning.value = false;
      timerValue.value = 0;

      
    } else {
      timerValue.value--;
    }
  });
}


  void pauseOrResume() {
    if (isRunning.value) {
      timer?.cancel();
      isRunning.value = false;
    } else {
      startTimer();
    }
  }

  void keGerakanSelanjutnya() {
  final nextIndex = indexGerakan.value + 1;
  if (nextIndex < daftarLatihan.length) {
    final nextGerakan = daftarLatihan[nextIndex];
    Get.offAndToNamed(
      '/latihan-v1', 
      arguments: {
        'gerakan': nextGerakan,
        'daftarLatihan': daftarLatihan,
        'index': nextIndex,
        'forceRefresh': true,
      },
    );
  } else {
    Get.back(); // kembali ke halaman latihan awal atau selesai
  }
}

  void keGerakanSebelumnya() {
    final prevIndex = indexGerakan.value - 1;
    if (prevIndex >= 0) {
      final prevGerakan = daftarLatihan[prevIndex];
      Get.offAndToNamed(
        '/latihan-v1',
        arguments: {
          'gerakan': prevGerakan,
          'daftarLatihan': daftarLatihan,
          'index': prevIndex,
          'forceRefresh': true,
        },
      );
    }
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
}
