import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:silat_mastery_app_2/app/modules/laporan/controllers/laporan_controller.dart';

class StatRingkasan extends GetView<LaporanController> {
  const StatRingkasan({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
            icon: Icons.emoji_events,
            value: controller.jumlahLatihan,
            label: "latihan",
          ),
          _StatItem(
            icon: Icons.local_fire_department,
            value: controller.totalKkal,
            label: "Kkal",
          ),
          _StatItem(
            icon: Icons.timer,
            value: controller.totalMenit,
            label: "Menit",
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final RxInt value;
  final String label;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.red),
        const SizedBox(height: 4),
        Obx(
          () => Text(
            value.toString(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Text(label),
      ],
    );
  }
}
