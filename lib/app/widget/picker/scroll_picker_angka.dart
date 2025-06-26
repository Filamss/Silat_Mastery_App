import 'package:flutter/material.dart';
import 'package:silat_mastery_app_2/app/widget/tema/app_warna.dart';

class ScrollPickerAngka extends StatelessWidget {
  final int min;
  final int max;
  final int selectedValue;
  final String satuan;
  final void Function(int) onSelected;
  final FixedExtentScrollController? controller;

  const ScrollPickerAngka({
    super.key,
    required this.min,
    required this.max,
    required this.selectedValue,
    required this.onSelected,
    required this.satuan,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Text(
          '$selectedValue $satuan',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        Stack(
          alignment: Alignment.center,
          children: [
            // Soft overlay fade (atas bawah)
            Positioned.fill(
              child: Column(
                children: [
                  Container(
                    height: 30,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.white, Colors.white.withOpacity(0)],
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    height: 30,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.white, Colors.white.withOpacity(0)],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable angka
            SizedBox(
              height: 130,
              child: ListWheelScrollView.useDelegate(
                controller: controller,
                itemExtent: 45,
                physics: const FixedExtentScrollPhysics(),
                onSelectedItemChanged: (index) => onSelected(index + min),
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: max - min + 1,
                  builder: (context, index) {
                    final value = min + index;
                    final isSelected = value == selectedValue;

                    return Center(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration:
                            isSelected
                                ? BoxDecoration(
                                  color:
                                      Colors
                                          .grey
                                          .shade200, // bisa diganti dengan warna highlight
                                  borderRadius: BorderRadius.circular(12),
                                )
                                : null,
                        child: Text(
                          value.toString(),
                          style: TextStyle(
                            fontSize: isSelected ? 22 : 16,
                            fontWeight:
                                isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                            color: isSelected ? AppWarna.utama : AppWarna.teks,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
