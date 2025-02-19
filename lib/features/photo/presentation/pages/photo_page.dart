import 'dart:math';

import 'package:coast/coast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_thesis_front_end/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:graduation_thesis_front_end/core/common/enum/app_enum.dart';
import 'package:graduation_thesis_front_end/core/common/layout/home_body_layout.dart';
import 'package:graduation_thesis_front_end/core/utils/show_snackbar.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/bloc/cubit/photo_view_mode_cubit.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/bloc/photo/photo_bloc.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/widget/view_mode/gallery_view_mode_selector.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/widget/view_mode/tab/gallery_all_view_mode.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/widget/view_mode/tab/gallery_month_view_mode.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/widget/view_mode/tab/gallery_year_view_mode.dart';
import 'package:graduation_thesis_front_end/init_dependencies.dart';
import 'package:lottie/lottie.dart';

// NOTE: move photo bloc to global level if needed
// for now -> page level
class PhotoPageContent extends StatefulWidget {
  const PhotoPageContent({super.key});

  @override
  State<PhotoPageContent> createState() => _PhotoPageContentState();
}

class _PhotoPageContentState extends State<PhotoPageContent> {
  @override
  void initState() {
    super.initState();
    context.read<PhotoBloc>().add(PhotoFetchAllEvent(
        userId:
            (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id));
  }

  final coastController = CoastController();

  final beaches = [
    Beach(builder: (context) => GalleryAllViewMode()),
    Beach(builder: (context) => GalleryMonthViewMode()),
    Beach(builder: (context) => GalleryYearViewMode()),
  ];

  @override
  Widget build(BuildContext context) {
    return BodyLayout(
      body: BlocConsumer<PhotoBloc, PhotoState>(listener: (context, state) {
        if (state is PhotoFetchFailure) {
          return showSnackBar(context, state.message);
        }
      }, builder: (context, state) {
        if (state is PhotoFetchLoading) {
          final random = Random().nextInt(2) + 1;
          return Scaffold(
              body: Center(
                  child: Lottie.asset(
                      'assets/lottie/loading${random == 1 ? '' : '_2'}.json',
                      height: 150)));
        } else {
          return BlocListener<PhotoViewModeCubit, PhotoViewModeState>(
            listener: (context, state) {
              if (state is PhotoViewModeChange) {
                switch (state.viewMode) {
                  case GalleryViewMode.all:
                    coastController.animateTo(beach: 0);
                    break;
                  case GalleryViewMode.months:
                    coastController.animateTo(beach: 1);
                    break;

                  case GalleryViewMode.years:
                    coastController.animateTo(beach: 2);
                    break;
                }
              }
            },
            child: Stack(
              children: [
                Coast(
                  onPageChanged: (int index) {
                    // if (index == 0) {
                    //   context
                    //       .read<PhotoViewModeCubit>()
                    //       .changeViewMode(GalleryViewMode.all);
                    // } else if (index == 1) {
                    //   context
                    //       .read<PhotoViewModeCubit>()
                    //       .changeViewMode(GalleryViewMode.all);
                    // } else if (index == 2) {
                    //   context
                    //       .read<PhotoViewModeCubit>()
                    //       .changeViewMode(GalleryViewMode.all);
                    // }
                  },
                  beaches: beaches,
                  controller: coastController,
                  observers: [
                    CrabController(),
                  ],
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: const Center(
                    child: GalleryViewModeSelector(),
                  ),
                ),
              ],
            ),
          );
        }
      }),
    );
  }
}

class PhotoPage extends StatelessWidget {
  const PhotoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => serviceLocator<PhotoBloc>()),
        BlocProvider(create: (_) => serviceLocator<PhotoViewModeCubit>()),
      ],
      child: PhotoPageContent(),
    );
  }
}
