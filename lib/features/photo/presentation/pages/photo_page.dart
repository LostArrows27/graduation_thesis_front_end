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

// NOTE: move photo bloc to global level if needed
// for now -> page level
class PhotoPage extends StatefulWidget {
  const PhotoPage({super.key});

  @override
  State<PhotoPage> createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final appUserState = context.read<AppUserCubit>().state;
        if (appUserState is AppUserLoggedIn) {
          final userId = appUserState.user.id;
          context.read<PhotoBloc>().add(PhotoFetchAllEvent(userId: userId));
          context
              .read<PhotoViewModeCubit>()
              .changeViewMode(GalleryViewMode.all);
        }
      }
    });
  }

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
          return Scaffold(
            body: Center(
                child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            )),
          );
        } else {
          return Stack(
            children: [
              BlocSelector<PhotoViewModeCubit, PhotoViewModeState,
                  GalleryViewMode?>(selector: (state) {
                if (state is PhotoViewModeChange) {
                  return state.viewMode;
                }
                return null;
              }, builder: (context, state) {
                if (state == null) {
                  return Center(
                    child: Text('Something wrong happened !'),
                  );
                } else {
                  return _selectViewModeWidget(state);
                }
              }),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: const Center(
                  child: GalleryViewModeSelector(),
                ),
              ),
            ],
          );
        }
      }),
    );
  }
}
