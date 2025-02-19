import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_thesis_front_end/core/common/cubit/app_user/app_user_cubit.dart';

class BodyLayout extends StatelessWidget {
  final Widget body;

  const BodyLayout({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AppUserCubit, AppUserState, AppUserLoggedIn?>(
      selector: (state) {
        if (state is AppUserLoggedIn) {
          return state;
        }
        return null;
      },
      builder: (context, state) {
        return Scaffold(
          body: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                floating: true,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Smart Gallery',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.notifications_outlined,
                                size: 26,
                                color: Theme.of(context).colorScheme.primary)),
                        SizedBox(width: 4),
                        IconButton(
                            style: IconButton.styleFrom(
                              padding: EdgeInsets.all(4),
                            ),
                            onPressed: () {},
                            icon: ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: SizedBox(
                                height: 32,
                                width: 32,
                                child: CachedNetworkImage(
                                  imageUrl: state!.user.avatarUrl!,
                                  placeholder: (context, url) => Container(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surfaceDim,
                                  ),
                                ),
                              ),
                            ))
                      ],
                    ),
                  ],
                ),
                automaticallyImplyLeading: false,
              )
            ],
            body: body,
          ),
        );
      },
    );
  }
}
