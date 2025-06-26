import 'package:flutter/material.dart';
import 'package:silat_mastery_app_2/app/widget/tema/app_warna.dart';

class ScrollPickerDesimalHorizontal extends StatefulWidget {
  final double min;
  final double max;
  final double interval;
  final double selectedValue;
  final String satuan;
  final void Function(double) onChanged;

  const ScrollPickerDesimalHorizontal({
    super.key,
    required this.min,
    required this.max,
    required this.interval,
    required this.selectedValue,
    required this.onChanged,
    this.satuan = "kg",
  });

  @override
  State<ScrollPickerDesimalHorizontal> createState() =>
      _ScrollPickerDesimalHorizontalState();
}

class _ScrollPickerDesimalHorizontalState
    extends State<ScrollPickerDesimalHorizontal> {
  late final ScrollController _scrollController;
  late final List<double> values;
  final double itemExtent = 60.0;

  @override
  void initState() {
    super.initState();

    values = List.generate(
      ((widget.max - widget.min) / widget.interval).round() + 1,
      (index) => double.parse(
        (widget.min + index * widget.interval).toStringAsFixed(1),
      ),
    );

    final initialIndex = values.indexWhere((e) => e == widget.selectedValue);
    _scrollController = ScrollController(
      initialScrollOffset: initialIndex * itemExtent,
    );
  }

  void _handleScrollEnd() {
    final offset = _scrollController.offset;
    final index = (offset / itemExtent).round().clamp(0, values.length - 1);
    final value = values[index];

    widget.onChanged(value);

    _scrollController.animateTo(
      index * itemExtent,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Text(
          '${widget.selectedValue.toStringAsFixed(1)} ${widget.satuan}',
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 80,
          child: Stack(
            children: [
              // Fade kiri
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: 40,
                child: IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Colors.white, Colors.white.withOpacity(0)],
                      ),
                    ),
                  ),
                ),
              ),

              // Fade kanan
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                width: 40,
                child: IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        colors: [Colors.white, Colors.white.withOpacity(0)],
                      ),
                    ),
                  ),
                ),
              ),

              // Scrollable angka
              NotificationListener<ScrollEndNotification>(
                onNotification: (notification) {
                  _handleScrollEnd();
                  return true;
                },
                child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  itemExtent: itemExtent,
                  itemCount: values.length,
                  padding: EdgeInsets.symmetric(
                    horizontal: (screenWidth - itemExtent) / 2,
                  ),
                  itemBuilder: (context, index) {
                    final value = values[index];
                    final isSelected = value == widget.selectedValue;

                    return Center(
                      child: Text(
                        value.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: isSelected ? 22 : 16,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? AppWarna.utama : AppWarna.abu,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
