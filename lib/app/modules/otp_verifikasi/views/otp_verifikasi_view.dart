import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:silat_mastery_app_2/app/modules/otp_verifikasi/controllers/otp_verifikasi_controller.dart';
import 'package:silat_mastery_app_2/app/widget/tema/app_gaya_teks.dart';
import 'package:silat_mastery_app_2/app/widget/tema/app_warna.dart';
import 'package:silat_mastery_app_2/app/widget/form/app_primary_button.dart';

class OtpVerifikasiView extends GetView<OtpVerifikasiController> {
  const OtpVerifikasiView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppWarna.latar,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              // Logo Silat Mastery
              Center(
                child: Image.asset(
                  'assets/img/Logo_Silat_Mastery.png',
                  width: 180,
                  height: 180,
                ),
              ),
              const SizedBox(height: 24),

              // Card OTP
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.black12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Masukkan Kode OTP", style: AppGayaTeks.judul),
                    const SizedBox(height: 8),
                    Text(
                      "Kode telah dikirimkan ke email anda",
                      style: AppGayaTeks.keterangan,
                    ),
                    const SizedBox(height: 20),

                    // OTP Input Fields
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(4, (index) {
                        return SizedBox(
                          width: 50,
                          child: TextField(
                            controller: controller.otpFields[index],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            style: AppGayaTeks.subJudul,
                            decoration: const InputDecoration(
                              counterText: "",
                              filled: true,
                              fillColor: Color(0xFFECECEC),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              if (value.isNotEmpty && index < 3) {
                                FocusScope.of(context).nextFocus();
                              }
                            },
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 16),

                    // Countdown Timer
                    Obx(() {
                      final countdown = controller.timer.value;
                      final isLoading = controller.isResending.value;

                      return Column(
                        children: [
                          Text(
                            "Tidak menerima kode?",
                            style: AppGayaTeks.keterangan,
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed:
                                countdown == 0 && !isLoading
                                    ? controller.resendOtp
                                    : null,
                            child: Text(
                              isLoading
                                  ? "Mengirim ulang..."
                                  : countdown > 0
                                  ? "Kirim ulang dalam $countdown dtk"
                                  : "Kirim ulang kode",
                              style: AppGayaTeks.keterangan.copyWith(
                                color:
                                    countdown > 0 ? Colors.grey : Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      );
                    }),

                    const SizedBox(height: 24),

                    // Tombol Verifikasi
                    AppPrimaryButton(
                      label: 'Verifikasi',
                      onPressed: controller.verifyOtp,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Get.toNamed('/register'),
                child: Text("Kembali ke Daftar", style: AppGayaTeks.keterangan),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
