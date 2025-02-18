import 'package:flutter/material.dart';

class PhotoPage extends StatelessWidget {
  const PhotoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            bottom: 24,
            left: 16,
            right: 16,
            child: const Center(
              child: ModeSelector(),
            ),
          ),
        ],
      ),
    );
  }
}

class ModeSelector extends StatefulWidget {
  const ModeSelector({super.key});

  @override
  State<ModeSelector> createState() => _ModeSelectorState();
}

class _ModeSelectorState extends State<ModeSelector> {
  int selectedIndex = 0;
  final int itemCount = 3;

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width - 32;
    final double padding = 6;
    final double itemWidth = (deviceWidth - 2 * padding) / itemCount;
    final double height = 45;

    return Container(
      height: height,
      width: deviceWidth,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(1, 4))
        ],
      ),
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: selectedIndex * itemWidth,
            top: 0,
            width: itemWidth,
            height: height - 2 * padding,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryFixedDim,
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
          Row(
            children: [
              _buildTab("All", 0, itemWidth),
              _buildTab("Months", 1, itemWidth),
              _buildTab("Years", 2, itemWidth),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index, double width) {
    final bool isSelected = (index == selectedIndex);
    return SizedBox(
      width: width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: () {
            setState(() => selectedIndex = index);
          },
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Theme.of(context).colorScheme.secondary
                    : Colors.black87,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
