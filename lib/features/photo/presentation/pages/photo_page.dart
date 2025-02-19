import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_thesis_front_end/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:graduation_thesis_front_end/core/common/enum/app_enum.dart';
import 'package:graduation_thesis_front_end/core/common/layout/home_body_layout.dart';
import 'package:graduation_thesis_front_end/core/common/widgets/lottie_loader.dart';
import 'package:graduation_thesis_front_end/core/utils/show_snackbar.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/bloc/cubit/photo_view_mode_cubit.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/bloc/photo/photo_bloc.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/widget/view_mode/gallery_view_mode_selector.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/widget/view_mode/tab/gallery_all_view_mode.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/widget/view_mode/tab/gallery_month_view_mode.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/widget/view_mode/tab/gallery_year_view_mode.dart';
import 'package:graduation_thesis_front_end/init_dependencies.dart';

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
    context.read<PhotoViewModeCubit>().changeViewMode(GalleryViewMode.all);
  }

  // NOTE: test with list -> not re-render
  // @override
  // Widget build(BuildContext context) {
  //   print('re-render');
  //   return ListView(
  //       children: List.generate(100, (index) {
  //     return Container(
  //       height: 100,
  //       child: Text('Item $index'),
  //     );
  //   }));
  // }

  // NOTE: test with BodyLayout -> not re-render
  // @override
  // Widget build(BuildContext context) {
  //   print('re-render');
  //   return BodyLayout(
  //       body: ListView(
  //           children: List.generate(100, (index) {
  //     return Container(
  //       height: 100,
  //       child: Text('Item $index'),
  //     );
  //   })));
  // }

  Widget _selectViewModeWidget(GalleryViewMode viewMode) {
    switch (viewMode) {
      case GalleryViewMode.all:
        return const GalleryAllViewMode(key: PageStorageKey('allViewMode'));
      case GalleryViewMode.months:
        return const GalleryMonthViewMode(key: PageStorageKey('monthViewMode'));
      case GalleryViewMode.years:
        return const GalleryYearViewMode(key: PageStorageKey('yearViewMode'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BodyLayout(
      body: BlocConsumer<PhotoBloc, PhotoState>(listener: (context, state) {
        if (state is PhotoFetchFailure) {
          return showSnackBar(context, state.message);
        }
      }, builder: (context, state) {
        if (state is PhotoFetchLoading) {
          return LottieLoader();
        } else {
          return BlocSelector<PhotoViewModeCubit, PhotoViewModeState,
              GalleryViewMode?>(
            selector: (state) {
              if (state is PhotoViewModeChange) {
                return state.viewMode;
              }
              return null;
            },
            builder: (context, state) => Stack(
              children: [
                state == null
                    ? Center(
                        child: Text('Something wrong happened !'),
                      )
                    : _selectViewModeWidget(state),
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
