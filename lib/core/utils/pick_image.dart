// ignore_for_file: use_build_context_synchronously

import 'dart:io';

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

Future<File?> selectLibraryImage(ImageSource imagesource, BuildContext context,
    [bool isPickingAvatar = true]) async {
  final pickedImage = await pickImage(imagesource);
  if (pickedImage != null) {
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
