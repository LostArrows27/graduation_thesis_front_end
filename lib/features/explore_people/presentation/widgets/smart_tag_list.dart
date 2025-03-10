import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_thesis_front_end/core/common/entities/image.dart';
import 'package:graduation_thesis_front_end/core/common/enum/app_enum.dart';
import 'package:graduation_thesis_front_end/core/common/widgets/cached_image.dart';
import 'package:graduation_thesis_front_end/core/routes/routes.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/bloc/photo/photo_bloc.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;

class SmartTagList extends StatefulWidget {
  const SmartTagList({super.key});

  @override
  State<SmartTagList> createState() => _SmartTagListState();
}

class _SmartTagListState extends State<SmartTagList> {
  Map<String, dynamic> countImageTags(SmartTagsType type, List<Photo> photos) {
    Set<String> tags = {};
    String coverUrl = '';

    final random = Random();
    List<Photo> imagesCollect = [];

    switch (type) {
      case SmartTagsType.location:
        for (var photo in photos) {
          if (photo.labels.labels.locationLabels.isNotEmpty) {
            tags.add(photo.labels.labels.locationLabels[0].label);
            imagesCollect.add(photo);
          }
        }
      case SmartTagsType.event:
        for (var photo in photos) {
          if (photo.labels.labels.eventLabels.isNotEmpty) {
            tags.add(photo.labels.labels.eventLabels[0].label);
            imagesCollect.add(photo);
          }
        }
      case SmartTagsType.activity:
        for (var photo in photos) {
          if (photo.labels.labels.actionLabels.isNotEmpty) {
            tags.add(photo.labels.labels.actionLabels[0].label);
            imagesCollect.add(photo);
          }
        }
      default:
        for (var photo in photos) {
          if (photo.labels.labels.locationLabels.isNotEmpty) {
            tags.add(photo.labels.labels.locationLabels[0].label);
            imagesCollect.add(photo);
          }
        }
    }

    if (imagesCollect.isNotEmpty) {
      coverUrl = imagesCollect[random.nextInt(imagesCollect.length)].imageUrl!;
    }

    return {'count': tags.length, 'url': coverUrl};
  }

  Widget smartTagTile(
    String coverUrl,
    String redirectUrl,
    SmartTagsType type,
    int count,
  ) {
    return Expanded(
        child: GestureDetector(
      onTap: () {
        context.push(redirectUrl, extra: type);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            height: 110,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: coverUrl != ''
                  ? CachedImage(imageUrl: coverUrl)
                  : Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            toBeginningOfSentenceCase(type.name),
            style: TextStyle(
              fontSize: 12,
            ),
          ),
          SizedBox(height: 3),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 10,
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhotoBloc, PhotoState>(
      builder: (context, state) {
        if (state is! PhotoFetchSuccess) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: Container(
                height: 110,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )),
              const SizedBox(width: 20),
              Expanded(
                  child: Container(
                height: 110,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )),
              const SizedBox(width: 20),
              Expanded(
                  child: Container(
                height: 110,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )),
            ],
          );
        }

        final locationTagsCount =
            countImageTags(SmartTagsType.location, (state).photos);
        final eventTagsCount =
            countImageTags(SmartTagsType.event, (state).photos);
        final activityTagsCount =
            countImageTags(SmartTagsType.activity, (state).photos);

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            smartTagTile(
                locationTagsCount['url'] as String,
                Routes.smartTagsViewerPage,
                SmartTagsType.location,
                locationTagsCount['count'] as int),
            const SizedBox(width: 20),
            smartTagTile(
                activityTagsCount['url'] as String,
                Routes.smartTagsViewerPage,
                SmartTagsType.activity,
                activityTagsCount['count'] as int),
            const SizedBox(width: 20),
            smartTagTile(
                eventTagsCount['url'] as String,
                Routes.smartTagsViewerPage,
                SmartTagsType.event,
                eventTagsCount['count'] as int),
          ],
        );
      },
    );
  }
}
