import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class LatihanV1Controller extends GetxController {
  final gerakan = <String, dynamic>{}.obs;
  final totalCountdown = 20;
  final countdown = 20.obs;

  Timer? timer;
  final AudioPlayer _audioPlayer = AudioPlayer();

  final indexGerakan = 0.obs;
  List<Map<String, dynamic>> daftarLatihan = [];

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      try {
        final rawDaftar = args['daftarLatihan'];
        final index = args['index'] ?? 0;
        final rawGerakan = args['gerakan'];
        if (rawGerakan != null) {
          try {
            gerakan.assignAll(Map<String, dynamic>.from(rawGerakan));
          } catch (e) {
            Get.snackbar('Error', 'Data gerakan tidak valid');
          }
        } else {}

        if (rawDaftar is List) {
          daftarLatihan = List<Map<String, dynamic>>.from(rawDaftar);
        }

        indexGerakan.value = index;

        startCountdown();
      } catch (e) {
        Get.snackbar('Error', 'Format data latihan tidak sesuai');
      }
    } else {
      Get.snackbar('Error', 'Data gerakan tidak ditemukan');
    }
  }

  void startCountdown() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) async {
      if (countdown.value <= 1) {
        t.cancel();
      } else {
        countdown.value--;

        if (countdown.value == 8) {
          try {
            await _audioPlayer.stop();
            await _audioPlayer.play(AssetSource('sounds/HitungMundur.mp3'));
            await _audioPlayer.onPlayerComplete.first;

            await _audioPlayer.stop();
            await _audioPlayer.play(AssetSource('sounds/Peluit.mp3'));
            await _audioPlayer.onPlayerComplete.first;

            navigateToLatihanV2();
          } catch (e) {
            debugPrint("❌ Gagal memutar audio: $e");
            navigateToLatihanV2();
          }
        }
      }
    });
  }

  void navigateToLatihanV2() {
    if (daftarLatihan.isNotEmpty && indexGerakan.value < daftarLatihan.length) {
      Get.offNamed(
        '/latihan-v2',
        arguments: {
          'gerakan': daftarLatihan[indexGerakan.value],
          'daftarLatihan': daftarLatihan,
          'index': indexGerakan.value,
        },
      );
    } else {
      Get.snackbar('Oops', 'Tidak ada gerakan tersedia.');
    }
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
}
