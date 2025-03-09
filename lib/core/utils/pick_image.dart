// ignore_for_file: use_build_context_synchronously

import 'dart:io';

// import 'package:exif/exif.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> pickImage([ImageSource imagesource = ImageSource.gallery]) async {
  try {
    final xFile = await ImagePicker().pickImage(
      source: imagesource,
    );
    if (xFile != null) {
      return File(xFile.path);
    }
    return null;
  } catch (e) {
    return null;
  }
}

Future<List<String>> pickMultiImages() async {
  try {
    final xFiles = await ImagePicker().pickMultiImage();
    return xFiles.map((e) => e.path).toList();
  } catch (e) {
    return [];
  }
}

Future<List<File>> pickMultiImagesFile() async {
  try {
    final xFiles = await ImagePicker().pickMultiImage();
    // xFiles.forEach((e) async {
    //   // NOTE: view exift metadata
    //   var bytes = await e.readAsBytes();
    //   var tags = await readExifFromBytes(bytes);
    //   tags.forEach((key, value) {
    //     if (key == 'EXIF DateTimeOriginal' || key == 'Image DateTime') {
    //       print("$key : $value");
    //     }
    //   });
    // });

    return xFiles.map((e) => File(e.path)).toList();
  } catch (e) {
    return [];
  }
}

// select 1 image + crop
Future<File?> selectLibraryImage(ImageSource imagesource, BuildContext context,
    [bool isPickingAvatar = true]) async {
  final pickedImage = await pickImage(imagesource);

  if (pickedImage != null) {
    // NOTE: view exift metadata
    // var bytes = await pickedImage.readAsBytes();
    // var tags = await readExifFromBytes(bytes);
    // tags.forEach((key, value) => print("$key : $value"));
    final croppedImage = await ImageCropper().cropImage(
        sourcePath: pickedImage.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Profile Image',
            toolbarColor: Theme.of(context).colorScheme.primary,
            activeControlsWidgetColor: Theme.of(context).colorScheme.secondary,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: isPickingAvatar
                ? CropAspectRatioPreset.square
                : CropAspectRatioPreset.original,
            lockAspectRatio: false,
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio16x9,
            ],
          ),
        ]);

    if (croppedImage != null) {
      return File(croppedImage.path);
    }
  }

  return null;
}
