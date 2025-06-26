import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingHelper {
  static bool _isShowing = false;

  static void show({String message = "Mohon tunggu..."}) {
    // Hindari membuka lebih dari satu dialog
    if (_isShowing || Get.isDialogOpen == true) return;
    _isShowing = true;

    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: Container(
          color: Colors.black.withOpacity(0.3),
          child: Center(
            child: Material(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
              child: Container(
                width: 220,
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 4),
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      strokeWidth: 3,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  static Future<void> hide() async {
    await Future.delayed(const Duration(milliseconds: 200));

    if (Get.isDialogOpen == true) {
      Get.back();
      await Future.delayed(const Duration(milliseconds: 100));
    }

    _isShowing = false;
  }
}
