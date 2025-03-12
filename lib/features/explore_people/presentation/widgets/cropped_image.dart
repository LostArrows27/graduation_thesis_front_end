import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CroppedImageWidget extends StatefulWidget {
  final String imageUrl;
  final Rect boundingBox;

  const CroppedImageWidget({
    super.key,
    required this.imageUrl,
    required this.boundingBox,
  });

  @override
  State<CroppedImageWidget> createState() => _CroppedImageWidgetState();
}

class _CroppedImageWidgetState extends State<CroppedImageWidget> {
  double? imgWidth;
  double? imgHeight;

  Future<void> _getImageDimensions(String imageUrl) async {
    final image = CachedNetworkImageProvider(imageUrl);
    final configuration = createLocalImageConfiguration(context);

    image.resolve(configuration).addListener(
      ImageStreamListener((ImageInfo imageInfo, bool synchronousCall) {
        setState(() {
          imgWidth = imageInfo.image.width.toDouble();
          imgHeight = imageInfo.image.height.toDouble();
        });
      }),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getImageDimensions(widget.imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    // If image dimensions are not available yet, show loading indicator
    if (imgWidth == null || imgHeight == null) {
      return Center(child: CircularProgressIndicator());
    }

    // Calculate fractional factors for width and height
    double regionWidth = widget.boundingBox.right - widget.boundingBox.left;
    double regionHeight = widget.boundingBox.bottom - widget.boundingBox.top;
    double widthFactor = regionWidth / imgWidth!;
    double heightFactor = regionHeight / imgHeight!;

    // Calculate alignment offsets
    double alignX =
        (widget.boundingBox.left / (imgWidth! - regionWidth)) * 2 - 1;
    double alignY =
        (widget.boundingBox.top / (imgHeight! - regionHeight)) * 2 - 1;
    Alignment regionAlignment = Alignment(alignX, alignY);

    return Container(
      constraints: const BoxConstraints(minWidth: 1, minHeight: 1),
      child: FittedBox(
        fit: BoxFit.cover, // scale uniformly to fit in container
        alignment: Alignment.topLeft,
        child: Container(
          constraints: const BoxConstraints(minWidth: 1, minHeight: 1),
          child: ClipRect(
            child: Align(
              alignment: regionAlignment,
              widthFactor: widthFactor,
              heightFactor: heightFactor,
              child: CachedNetworkImage(
                imageUrl: widget.imageUrl,
                fit: BoxFit.none, // do not scale the image itself
              ),
            ),
          ),
        ),
      ),
    );
  }
}
