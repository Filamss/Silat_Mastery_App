import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/artikel_detail_controller.dart';

class ArtikelDetailView extends GetView<ArtikelDetailController> {
  const ArtikelDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ArtikelDetailView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ArtikelDetailView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
