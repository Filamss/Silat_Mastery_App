import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class PengaturanController extends GetxController {
  var syncHealth = false.obs;

  void toggleHealthSync(bool value) {
    syncHealth.value = value;
  }

  void logout() {
    Get.dialog(
      AlertDialog(
        title: const Text("Konfirmasi Keluar"),
        content: const Text("Apakah kamu yakin ingin keluar dari akun?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(), // Tutup dialog
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () async {
              final box = GetStorage();
              await box.erase();
              Get.offAllNamed('/login');
            },
            child: const Text("Keluar"),
          ),
        ],
      ),
    );
  }
}
