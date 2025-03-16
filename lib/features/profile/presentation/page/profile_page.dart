import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_thesis_front_end/core/common/widgets/cached_image.dart';
import 'package:graduation_thesis_front_end/core/utils/get_color_scheme.dart';
import 'package:graduation_thesis_front_end/core/utils/group_image_by_location.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:graduation_thesis_front_end/features/explore_people/presentation/bloc/person_group/person_group_bloc.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/bloc/photo/photo_bloc.dart';
import 'package:graduation_thesis_front_end/features/profile/presentation/utils/format_profile_date.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is! AuthSuccess) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: getColorScheme(context).primary, width: 3),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: CachedImage(
                            borderRadius: 60, imageUrl: state.user.avatarUrl!),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      '@${state.user.name}',
                      style: TextStyle(
                        fontSize: 22,
                        color: getColorScheme(context).primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 30),
                    IntrinsicHeight(
                      child: Row(
                        children: [
                          BlocBuilder<PhotoBloc, PhotoState>(
                            builder: (context, state) {
                              return Expanded(
                                  child: Column(
                                children: [
                                  Text(
                                    '${state is! PhotoFetchSuccess ? 0 : state.photos.length}',
                                    style: TextStyle(
                                        color:
                                            getColorScheme(context).secondary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Photos',
                                    style: TextStyle(
                                        color: getColorScheme(context).outline,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ));
                            },
                          ),
                          VerticalDivider(
                            width: 1,
                            color: getColorScheme(context).outline,
                            thickness: 1,
                          ),
                          BlocBuilder<PersonGroupBloc, PersonGroupState>(
                            builder: (context, state) {
                              return Expanded(
                                  child: Column(
                                children: [
                                  Text(
                                    '${state is! PersonGroupSuccess ? 0 : state.personGroups.length}',
                                    style: TextStyle(
                                        color:
                                            getColorScheme(context).secondary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'People',
                                    style: TextStyle(
                                        color: getColorScheme(context).outline,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ));
                            },
                          ),
                          VerticalDivider(
                            width: 2,
                            color: getColorScheme(context).primary,
                            thickness: 1,
                          ),
                          BlocBuilder<PhotoBloc, PhotoState>(
                            builder: (context, state) {
                              var totalLocation = 0;

                              if (state is PhotoFetchSuccess) {
                                totalLocation =
                                    groupImageByLocation(state.photos).length;
                              }

                              return Expanded(
                                  child: Column(
                                children: [
                                  Text(
                                    '$totalLocation',
                                    style: TextStyle(
                                        color:
                                            getColorScheme(context).secondary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Locations',
                                    style: TextStyle(
                                        color: getColorScheme(context).outline,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ));
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: 45),
                          Text(
                            'General',
                            style: TextStyle(
                              fontSize: 20,
                              color: getColorScheme(context).primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 30),
                          Row(
                            children: [
                              SizedBox(width: 10),
                              Icon(Icons.person_outline, size: 28),
                              SizedBox(width: 20),
                              Text(
                                state.user.name,
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 35),
                          Row(
                            children: [
                              SizedBox(width: 10),
                              Icon(Icons.email_outlined, size: 28),
                              SizedBox(width: 20),
                              Text(
                                state.user.email,
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 35),
                          Row(
                            children: [
                              SizedBox(width: 10),
                              Icon(Icons.cake_outlined, size: 28),
                              SizedBox(width: 20),
                              Text(
                                formatBirthday(state.user.dob!),
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 35),
                          Row(
                            children: [
                              SizedBox(width: 10),
                              Icon(Icons.watch_later_outlined, size: 28),
                              SizedBox(width: 20),
                              Text(
                                'Joined at ${formatJoinedDate(state.user.createdAt!)}',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 80),
                    SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton(
                            onPressed: () {
                              context.read<AuthBloc>().add(AuthSignOut());
                            },
                            child: Text('Sign out')))
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
