import 'package:flutter/material.dart';

// NOTE: option form -> can skip
// skip -> set isDoneLabelForm = true in database
class UploadImageLabel extends StatefulWidget {
  const UploadImageLabel({super.key});

  static const path = '/information/upload-image-label';

  @override
  State<UploadImageLabel> createState() => _UploadImageLabelState();
}

class _UploadImageLabelState extends State<UploadImageLabel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image Label'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Upload Image Label Page'),
          ],
        ),
      ),
    );
  }
}
