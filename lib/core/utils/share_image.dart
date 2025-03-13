import 'dart:io';
import 'dart:typed_data';
import 'package:extended_image/extended_image.dart';
import 'package:graduation_thesis_front_end/core/common/entities/image.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

Future<void> shareImages(Photo photo) async {
  File? tempFile;
  try {
    Uint8List? imageData =
        await ExtendedNetworkImageProvider(photo.imageUrl!, cache: true)
            .getNetworkImageData();

    final directory = await getTemporaryDirectory();
    tempFile = File('${directory.path}/shared_image.jpg');

    if (imageData == null) {
      throw Exception('Failed to load image data');
    }

    await tempFile.writeAsBytes(imageData);

    await Share.shareXFiles([XFile(tempFile.path)],
        text: photo.caption ?? 'Check out this image on Smart Gallery!');
  } catch (e, c) {
    print("Error sharing the image: $e");
    print(c);
  } finally {
    try {
      if (tempFile != null && await tempFile.exists()) {
        await tempFile.delete();
      }
    } catch (e, c) {
      print("Error deleting temporary file: $e");
      print(c);
    }
  }
}
