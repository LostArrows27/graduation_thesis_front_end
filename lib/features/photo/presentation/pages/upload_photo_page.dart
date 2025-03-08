import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_thesis_front_end/core/routes/routes.dart';
import 'package:graduation_thesis_front_end/core/utils/show_snackbar.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/bloc/photo/photo_bloc.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/bloc/upload_photo/bloc/upload_photo_bloc.dart';
import 'package:graduation_thesis_front_end/init_dependencies.dart';

class UploadPhotoPage extends StatefulWidget {
  final List<File> imageFiles;

  const UploadPhotoPage({super.key, required this.imageFiles});

  @override
  State<UploadPhotoPage> createState() => _UploadPhotoPageState();
}

class _UploadPhotoPageState extends State<UploadPhotoPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<UploadPhotoBloc>(),
      child: UploadPhotoPageBody(widget: widget),
    );
  }
}

class UploadPhotoPageBody extends StatelessWidget {
  const UploadPhotoPageBody({
    super.key,
    required this.widget,
  });

  final UploadPhotoPage widget;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UploadPhotoBloc, UploadPhotoState>(
      listener: (context, state) {
        if (state is UploadImagesFailure) {
          return showErrorSnackBar(context, state.message);
        }

        if (state is UploadImageSuccess) {
          return context
              .read<PhotoBloc>()
              .add(PhotoAddImagesEvent(photos: state.photos));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: FilledButton(
                    onPressed: state is UploadImagesLoading
                        ? null
                        : state is UploadImageSuccess
                            ? () {
                                context.go(Routes.photosPage);
                              }
                            : () {
                                context.read<UploadPhotoBloc>().add(
                                    UploadImagesEvent(
                                        images: widget.imageFiles));
                              },
                    child: Text(
                      state is UploadImageSuccess ? "Done" : "Save",
                    )),
              )
            ],
          ),
          body: Center(
            child: Column(
              children: [
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      Text(
                        "Upload Your Photo!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "And let's see what label it is!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          height: 1.5,
                          fontSize: 15,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 70),
                CarouselSlider.builder(
                    itemCount: widget.imageFiles.length,
                    itemBuilder: (context, index, realIndex) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        height: 450,
                        child: GestureDetector(
                          onTap: () async {},
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHigh,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.secondary,
                                width: 5,
                              ),
                            ),
                            child: state is UploadImagesLoading
                                ? (Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: ColorFiltered(
                                          colorFilter: ColorFilter.mode(
                                            Colors.black.withAlpha(150),
                                            BlendMode.saturation,
                                          ),
                                          child: ClipRRect(
                                            child: Image.file(
                                              widget.imageFiles[index],
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: CircularProgressIndicator(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      )
                                    ],
                                  ))
                                : Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.file(
                                          widget.imageFiles[index],
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        ),
                                      ),
                                      state is UploadImageSuccess
                                          ? Positioned.fill(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Container(
                                                    height: 200,
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      color: Colors.black38,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(20),
                                                        bottomRight:
                                                            Radius.circular(20),
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(20),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          state
                                                                  .photos[index]
                                                                  .labels
                                                                  .labels
                                                                  .locationLabels
                                                                  .isNotEmpty
                                                              ? Wrap(
                                                                  spacing:
                                                                      15, // gap between adjacent chips
                                                                  runSpacing:
                                                                      10, // gap between Lines,
                                                                  children: [
                                                                    ...state
                                                                        .photos[
                                                                            index]
                                                                        .labels
                                                                        .labels
                                                                        .locationLabels
                                                                        .map(
                                                                      (e) =>
                                                                          Chip(
                                                                        visualDensity: const VisualDensity(
                                                                            horizontal:
                                                                                0.0,
                                                                            vertical:
                                                                                -4),
                                                                        backgroundColor: Theme.of(context)
                                                                            .colorScheme
                                                                            .secondary,
                                                                        shape: RoundedRectangleBorder(
                                                                            side:
                                                                                BorderSide(color: Theme.of(context).colorScheme.secondary, width: 1),
                                                                            borderRadius: BorderRadius.circular(20)),
                                                                        label:
                                                                            Text(
                                                                          e.label,
                                                                          style: TextStyle(
                                                                              fontSize: 10,
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.w600),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    ...state
                                                                        .photos[
                                                                            index]
                                                                        .labels
                                                                        .labels
                                                                        .eventLabels
                                                                        .map(
                                                                      (e) =>
                                                                          Chip(
                                                                        visualDensity: const VisualDensity(
                                                                            horizontal:
                                                                                0.0,
                                                                            vertical:
                                                                                -4),
                                                                        backgroundColor: Theme.of(context)
                                                                            .colorScheme
                                                                            .secondary,
                                                                        shape: RoundedRectangleBorder(
                                                                            side:
                                                                                BorderSide(color: Theme.of(context).colorScheme.secondary, width: 1),
                                                                            borderRadius: BorderRadius.circular(20)),
                                                                        label:
                                                                            Text(
                                                                          e.label,
                                                                          style: TextStyle(
                                                                              fontSize: 10,
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.w600),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    ...state
                                                                        .photos[
                                                                            index]
                                                                        .labels
                                                                        .labels
                                                                        .actionLabels
                                                                        .map(
                                                                      (e) =>
                                                                          Chip(
                                                                        visualDensity: const VisualDensity(
                                                                            horizontal:
                                                                                0.0,
                                                                            vertical:
                                                                                -4),
                                                                        backgroundColor: Theme.of(context)
                                                                            .colorScheme
                                                                            .tertiary,
                                                                        shape: RoundedRectangleBorder(
                                                                            side:
                                                                                BorderSide(color: Theme.of(context).colorScheme.tertiary, width: 1),
                                                                            borderRadius: BorderRadius.circular(20)),
                                                                        label:
                                                                            Text(
                                                                          e.label,
                                                                          style: TextStyle(
                                                                              fontSize: 10,
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.w600),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                )
                                                              : Wrap(
                                                                  spacing: 15,
                                                                  runSpacing:
                                                                      10,
                                                                  children: [
                                                                    Chip(
                                                                      visualDensity: const VisualDensity(
                                                                          horizontal:
                                                                              0.0,
                                                                          vertical:
                                                                              -4),
                                                                      backgroundColor: Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .error,
                                                                      shape: RoundedRectangleBorder(
                                                                          side: BorderSide(
                                                                              color: Theme.of(context).colorScheme.error,
                                                                              width: 1),
                                                                          borderRadius: BorderRadius.circular(20)),
                                                                      label:
                                                                          Text(
                                                                        "Error labeling this image",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                10,
                                                                            color:
                                                                                Colors.white,
                                                                            fontWeight: FontWeight.w600),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                          ),
                        ),
                      );
                    },
                    options: CarouselOptions(
                        height: 500,
                        enlargeCenterPage: true,
                        enlargeFactor: 0.25,
                        enlargeStrategy: CenterPageEnlargeStrategy.scale))
              ],
            ),
          ),
        );
      },
    );
  }
}
