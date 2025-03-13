import 'dart:typed_data';
import 'package:extended_image/extended_image.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:graduation_thesis_front_end/core/common/entities/image.dart';
import 'package:graduation_thesis_front_end/core/utils/show_snackbar.dart';

// saved to: /storage/emulated/0/Android/data/com.example.graduation_thesis_front_end/files/

Future<void> saveImage(BuildContext context, Photo photo) async {
  try {
    Uint8List? imageData =
        await ExtendedNetworkImageProvider(photo.imageUrl!, cache: true)
            .getNetworkImageData();

    String safeName = (photo.caption ?? photo.imageName)
        .replaceAll(RegExp(r'[^\w\s.-]'), '')
        .replaceAll(RegExp(r'\s+'), '_');

    String result = await FileSaver.instance.saveFile(
        name: safeName, bytes: imageData, ext: 'jpg', mimeType: MimeType.jpeg);

    print('File saved to: $result');

    showSnackBar(context, 'Image saved successfully !');
  } catch (e, c) {
    print("Error saving the image: $e");
    print(c);
    showErrorSnackBar(context, 'Failed to save the image !');
  }
}
