import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_thesis_front_end/core/routes/routes.dart';

class VideoRenderStatusPage extends StatelessWidget {
  const VideoRenderStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            context.go(Routes.photosPage);
          },
        ),
        title: Text(
          'Recap Video Status',
          style: TextStyle(fontSize: 20),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add photo to your video',
        onPressed: () {
          // NOTE: un-comment for dev process
          // context.push(Routes.editVideoSchemaPage, extra: fakeVideoSchema);
          // context.push(Routes.videoImagePickerPage);
          context.push(Routes.videoRenderResult,
              extra: "2854975a-8f26-498a-9c5c-6c2461652778");
        },
        child: Icon(Icons.add_photo_alternate_outlined),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Center(
        child: Text('TODO: display video render status later✅✅'),
      ),
    );
  }
}

// NOTE: remove duplicate image
