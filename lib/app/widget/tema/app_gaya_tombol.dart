import 'package:flutter/material.dart';
import 'app_warna.dart';

class AppGayaTombol {
  /// Tombol utama (merah terang)
  static final ButtonStyle utama = ElevatedButton.styleFrom(
    backgroundColor: AppWarna.utama,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
  );

  /// Tombol sekunder (outline warna merah marun)
  static final ButtonStyle sekunder = OutlinedButton.styleFrom(
    foregroundColor: AppWarna.kedua,
    side: const BorderSide(color: AppWarna.kedua),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
  );

  /// Tombol info (misalnya untuk onboarding berikutnya)
  static final ButtonStyle info = ElevatedButton.styleFrom(
    backgroundColor: AppWarna.utama,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
  );
}
