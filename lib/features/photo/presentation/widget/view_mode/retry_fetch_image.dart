import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_thesis_front_end/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/bloc/photo/photo_bloc.dart';

class RetryFetchImage extends StatelessWidget {
  const RetryFetchImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('No image found'),
          SizedBox(height: 20),
          SizedBox(
            width: 120,
            child: FilledButton(
              onPressed: () {
                final userId =
                    (context.read<AppUserCubit>().state as AppUserLoggedIn)
                        .user
                        .id;

                context
                    .read<PhotoBloc>()
                    .add(PhotoFetchAllEvent(userId: userId));
              },
              child: Text('Retry'),
            ),
          ),
        ],
      ),
    );
  }
}
