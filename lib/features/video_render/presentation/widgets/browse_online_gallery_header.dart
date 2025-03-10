import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_thesis_front_end/core/common/enum/app_enum.dart';
import 'package:graduation_thesis_front_end/features/album/presentation/bloc/cubit/choose_image_mode_cubit.dart';

class BrowseOnlineGalleryHeader extends StatelessWidget {
  final String title;

  const BrowseOnlineGalleryHeader(
      {super.key, this.title = 'Browse Your Online Gallery'});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChooseImageModeCubit, ChooseImageModeState>(
      builder: (context, state) {
        return Column(
          children: [
            Container(
              height: 4,
              width: 50,
              color: Colors.grey[300],
            ),
            SizedBox(height: 20),
            Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 12),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Material(
                      color: Colors.transparent,
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        splashColor:
                            Theme.of(context).colorScheme.primary.withAlpha(13),
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: const Icon(
                            Icons.close,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: state is ChooseImageModeChange &&
                                      state.mode == ChooseImageMode.all
                                  ? Theme.of(context)
                                      .colorScheme
                                      .tertiaryContainer
                                  : Theme.of(context).colorScheme.tertiaryFixed,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                            ),
                            onPressed: () {
                              BlocProvider.of<ChooseImageModeCubit>(context)
                                  .changeViewMode(ChooseImageMode.all);
                            },
                            child: Text(
                              'Photos',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onTertiaryContainer),
                            )),
                        SizedBox(width: 10),
                        FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: state is ChooseImageModeChange &&
                                      state.mode == ChooseImageMode.album
                                  ? Theme.of(context)
                                      .colorScheme
                                      .tertiaryContainer
                                  : Theme.of(context).colorScheme.tertiaryFixed,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                            ),
                            onPressed: () {
                              BlocProvider.of<ChooseImageModeCubit>(context)
                                  .changeViewMode(ChooseImageMode.album);
                            },
                            child: Text(
                              'Albums',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onTertiaryFixed),
                            ))
                      ],
                    ),
                    Material(
                      color: Colors.transparent,
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        splashColor:
                            Theme.of(context).colorScheme.primary.withAlpha(13),
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: const Icon(
                            Icons.more_vert,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
