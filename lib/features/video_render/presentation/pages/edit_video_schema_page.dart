import 'package:flutter/material.dart';
import 'package:graduation_thesis_front_end/features/video_render/domain/entities/video_schema.dart';

class EditVideoSchemaPage extends StatelessWidget {
  final VideoSchema videoSchema;

  const EditVideoSchemaPage({super.key, required this.videoSchema});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      )),
      body: Center(
        child: Text('Edit Video Schema Page'),
      ),
    );
  }
}
