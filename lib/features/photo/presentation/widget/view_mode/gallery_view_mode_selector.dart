import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_thesis_front_end/core/common/enum/app_enum.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/bloc/cubit/photo_view_mode_cubit.dart';

class GalleryViewModeSelector extends StatefulWidget {
  const GalleryViewModeSelector({super.key});

  @override
  State<GalleryViewModeSelector> createState() =>
      _GalleryViewModeSelectorState();
}

class _GalleryViewModeSelectorState extends State<GalleryViewModeSelector> {
  int selectedIndex = 0;
  final int itemCount = 3;

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width - 32;
    final double padding = 6;
    final double itemWidth = (deviceWidth - 2 * padding) / itemCount;
    final double height = 45;

    return BlocConsumer<PhotoViewModeCubit, PhotoViewModeState>(
      listener: (context, state) {
        if (state is PhotoViewModeChange) {
          var viewMode = state.viewMode;
          switch (viewMode) {
            case GalleryViewMode.all:
              setState(() => selectedIndex = 0);
              break;
            case GalleryViewMode.months:
              setState(() => selectedIndex = 1);
              break;
            case GalleryViewMode.years:
              setState(() => selectedIndex = 2);
              break;
          }
        }
      },
      builder: (context, state) => Container(
        height: height,
        width: deviceWidth,
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 10, offset: Offset(1, 4))
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
                  color: Theme.of(context).colorScheme.primaryFixedDim,
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
            Row(
              children: [
                _buildTab(context, "All", 0, itemWidth, GalleryViewMode.all),
                _buildTab(
                    context, "Months", 1, itemWidth, GalleryViewMode.months),
                _buildTab(
                    context, "Years", 2, itemWidth, GalleryViewMode.years),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(BuildContext context, String label, int index, double width,
      GalleryViewMode mode) {
    final bool isSelected = (index == selectedIndex);
    return SizedBox(
      width: width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: () {
            setState(() => selectedIndex = index);
            context.read<PhotoViewModeCubit>().changeViewMode(mode);
          },
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                  color: isSelected
                      ? Theme.of(context).colorScheme.inverseSurface
                      : Colors.black54,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }
}
