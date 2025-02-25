import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:graduation_thesis_front_end/features/video_render/domain/entities/selected_image.dart';

class SelectedImagePreview extends StatefulWidget {
  final bool isSelected;
  final SelectedImage image;
  final int index;
  final Function(String url) removeImage;
  final bool isLoading;

  const SelectedImagePreview(
      {super.key,
      this.isSelected = false,
      this.isLoading = false,
      required this.image,
      required this.removeImage,
      required this.index});

  @override
  State<SelectedImagePreview> createState() => _SelectedImagePreviewState();
}

class _SelectedImagePreviewState extends State<SelectedImagePreview> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            margin: widget.index != 0
                ? EdgeInsets.only(left: 0)
                : EdgeInsets.only(left: 10),
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: widget.image.source == Source.offline
                      ? FileImage(File(widget.image.filePath))
                      : CachedNetworkImageProvider(widget.image.filePath)),
            ),
          ),
        ),
        widget.isLoading
            ? Positioned(
                top: 8,
                left: widget.index != 0 ? 9 : 17,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black38,
                  ),
                  width: 72,
                  height: 72,
                ),
              )
            : Container(),
        widget.isLoading
            ? Positioned(
                top: 28,
                left: widget.index != 0 ? 28 : 37,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.transparent,
                  ),
                  width: 30,
                  height: 30,
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).colorScheme.primaryContainer),
                    ),
                  ),
                ),
              )
            : Container(),
        Positioned(
          left: widget.index != 0 ? -10 : -5,
          top: -10,
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(
              maxWidth: 22,
              maxHeight: 22,
              minHeight: 22,
              minWidth: 22,
            ),
            onPressed: () {
              if (widget.isLoading) {
                return;
              }
              widget.removeImage(widget.image.filePath);
            },
            iconSize: 14,
            icon: Icon(
              Icons.close,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            ),
          ),
        ),
      ],
    );
  }
}
