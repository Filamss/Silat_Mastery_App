import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:silat_mastery_app_2/app/widget/tema/app_gaya_teks.dart';
import 'package:silat_mastery_app_2/app/widget/tema/app_warna.dart';

class AnalisisStreamlitCard extends StatelessWidget {
  const AnalisisStreamlitCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => const _StreamlitWebView());
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: AppWarna.utama.withOpacity(0.1),
          border: Border.all(color: AppWarna.utama),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(Icons.bar_chart, color: AppWarna.utama),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Analisis Kemajuan", style: AppGayaTeks.subJudul),
                  const SizedBox(height: 4),
                  Text(
                    "Lihat performa latihan kamu di dashboard analisis.",
                    style: AppGayaTeks.keterangan,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppWarna.utama,
            ),
          ],
        ),
      ),
    );
  }
}

class _StreamlitWebView extends StatefulWidget {
  const _StreamlitWebView();

  @override
  State<_StreamlitWebView> createState() => _StreamlitWebViewState();
}

class _StreamlitWebViewState extends State<_StreamlitWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    final PlatformWebViewControllerCreationParams params =
        const PlatformWebViewControllerCreationParams();

    _controller =
        WebViewController.fromPlatformCreationParams(params)
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(
            Uri.parse(
              'https://silat-scrapping-3bemaqky66srkofuphvsfg.streamlit.app/',
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Analisis Berita"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
