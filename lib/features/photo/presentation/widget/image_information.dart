import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:graduation_thesis_front_end/core/utils/get_color_scheme.dart';

class ImageInformation extends StatefulWidget {
  final String imageUrl;
  final String name;

  const ImageInformation(
      {super.key, required this.imageUrl, required this.name});

  @override
  State<ImageInformation> createState() => _ImageInformationState();
}

class _ImageInformationState extends State<ImageInformation> {
  double imageMbSize = 1.2;
  int imageWidth = 1980;
  int imageHeight = 1080;

  Future<void> _getImageDimensions(String imageUrl) async {
    final image = ExtendedNetworkImageProvider(imageUrl, cache: true);
    final configuration = createLocalImageConfiguration(context);

    image.resolve(configuration).addListener(
      ImageStreamListener((ImageInfo imageInfo, bool synchronousCall) {
        setState(() {
          imageWidth = imageInfo.image.width.toInt();
          imageHeight = imageInfo.image.height.toInt();
          imageMbSize = (imageInfo.image.height *
              imageInfo.image.width *
              32 /
              8 /
              1024 /
              1024);
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
    return Padding(
      padding: EdgeInsets.only(left: 10),
      child: Row(
        children: [
          Icon(
            Icons.image_outlined,
            size: 24,
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  '${imageMbSize.toStringAsFixed(2)}Mb・${imageWidth.toString()} x ${imageHeight.toString()}',
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                      fontSize: 12, color: getColorScheme(context).outline),
                ),
              ],
            ),
          ),
          SizedBox(width: 20),
        ],
      ),
    );
  }
}
