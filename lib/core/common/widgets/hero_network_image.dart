import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class HeroNetworkImage extends StatefulWidget {
  final String imageUrl;
  final Object heroTag;
  final BoxFit fit;
  final double borderRadius;

  const HeroNetworkImage(
      {super.key,
      required this.imageUrl,
      required this.heroTag,
      this.fit = BoxFit.cover,
      this.borderRadius = 0});

  @override
  State<HeroNetworkImage> createState() => _HeroNetworkImageState();
}

class _HeroNetworkImageState extends State<HeroNetworkImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 800),
        lowerBound: 0.0,
        upperBound: 1.0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: widget.heroTag,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceDim,
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: ExtendedImage.network(
            widget.imageUrl,
            fit: widget.fit,
            cache: true,
            loadStateChanged: (ExtendedImageState state) {
              switch (state.extendedImageLoadState) {
                case LoadState.loading:
                  _controller.reset();
                  return Container();
                case LoadState.completed:
                  if (state.wasSynchronouslyLoaded) {
                    return state.completedWidget;
                  }
                  _controller.forward();
                  return FadeTransition(
                    opacity: _controller,
                    child: state.completedWidget,
                  );
                case LoadState.failed:
                  _controller.reset();
                  state.imageProvider.evict();
                  return GestureDetector(
                    child: Container(
                      color: Theme.of(context).colorScheme.surfaceDim,
                      child: Icon(
                        Icons.error,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    onTap: () {
                      state.reLoadImage();
                    },
                  );
              }
            },
          ),
        ),
      ),
    );
  }
}
