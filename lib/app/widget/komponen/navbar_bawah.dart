import 'package:flutter/material.dart';
import 'package:silat_mastery_app_2/app/widget/tema/app_warna.dart';

class NavbarBawah extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const NavbarBawah({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      selectedItemColor: AppWarna.utama,
      unselectedItemColor: Colors.grey.shade400,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.fitness_center),label: 'Latihan',),
        BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Jelajah'),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Laporan'),
        BottomNavigationBarItem(icon: Icon(Icons.settings),label: 'Pengaturan',),
      ],
    );
  }
}
