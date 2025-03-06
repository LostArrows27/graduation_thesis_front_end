import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_thesis_front_end/core/common/layout/home_body_layout.dart';
import 'package:graduation_thesis_front_end/core/common/widgets/failure.dart';
import 'package:graduation_thesis_front_end/core/common/widgets/loader.dart';
import 'package:graduation_thesis_front_end/core/routes/routes.dart';
import 'package:graduation_thesis_front_end/core/utils/show_snackbar.dart';
import 'package:graduation_thesis_front_end/features/explore_people/domain/entities/person_group.dart';
import 'package:graduation_thesis_front_end/features/explore_people/presentation/bloc/person_group/person_group_bloc.dart';
import 'package:graduation_thesis_front_end/features/explore_people/presentation/widgets/cropped_image.dart';

class ExplorePageFake extends StatefulWidget {
  const ExplorePageFake({super.key});

  @override
  State<ExplorePageFake> createState() => _ExplorePageFakeState();
}

class _ExplorePageFakeState extends State<ExplorePageFake> {
  @override
  Widget build(BuildContext context) {
    return ExploreBodyPage();
  }
}

class ExploreBodyPage extends StatefulWidget {
  const ExploreBodyPage({super.key});

  @override
  State<ExploreBodyPage> createState() => _ExploreBodyPageState();
}

class _ExploreBodyPageState extends State<ExploreBodyPage> {
  List<PersonGroup> personGroups = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PersonGroupBloc>().add(PersonGroupFetch());
    });
  }

  Widget imageTitle(PersonGroup? personGroup, BuildContext context) {
    if (personGroup == null ||
        personGroup.faces.isEmpty ||
        personGroup.faces[0].imageUrl.isEmpty) {
      return Expanded(
          child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
        ),
      ));
    } else {
      final [top, right, bottom, left] =
          personGroup.faces[0].coordinate.map((e) => e.toDouble()).toList();
      return Expanded(
          child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CroppedImageWidget(
                imageUrl: personGroup.faces[0].imageUrl,
                boundingBox: Rect.fromLTRB(left, top, right, bottom))),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BodyLayout(
      body: BlocConsumer<PersonGroupBloc, PersonGroupState>(
        listener: (context, state) {
          if (state is PersonGroupFailure) {
            return showErrorSnackBar(context, state.message);
          }

          if (state is PersonGroupSuccess) {
            return setState(() {
              personGroups = state.personGroups;
            });
          }

          if (state is ChangeGroupNameSuccess) {
            return setState(() {
              personGroups = state.personGroups;
            });
          }
        },
        builder: (context, state) {
          if (state is PersonGroupFailure) {
            return FailureWidget(message: 'Failed to fetch people data.');
          }

          if (state is PersonGroupLoading || state is PersonGroupInitial) {
            return Loader();
          }

          if (state is! PersonGroupSuccess &&
              state is! ChangeGroupNameSuccess) {
            return FailureWidget(message: 'Failed to fetch people data.');
          }

          if (personGroups.isEmpty) {
            return FailureWidget(message: 'No people data.');
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'People & Place',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Material(
                            borderRadius: BorderRadius.circular(20),
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerLow,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {
                                context.push(Routes.peopleExplorePage,
                                    extra: personGroups);
                              },
                              splashColor: Colors.black12,
                              child: Container(
                                height: 172,
                                width: 172,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                // 4 gray circle, 2 circle a row
                                child: Padding(
                                  padding: const EdgeInsets.all(14),
                                  child: Column(
                                    children: [
                                      // Expanded(
                                      //     child: Row(
                                      //   children: [
                                      //     imageTitle(
                                      //         'https://i.pinimg.com/736x/cc/80/f3/cc80f38579887963c2d71d7060081ea3.jpg',
                                      //         context),
                                      //     SizedBox(width: 10),
                                      //     imageTitle(
                                      //         'https://i.pinimg.com/736x/cf/24/ab/cf24abad1e4971fc143033cae9e02b3f.jpg',
                                      //         context)
                                      //   ],
                                      // )),
                                      // SizedBox(height: 10),
                                      // Expanded(
                                      //     child: Row(
                                      //   children: [
                                      //     imageTitle(
                                      //         'https://i.pinimg.com/736x/d7/f3/19/d7f319490dd5b677a85389e5b59cee09.jpg',
                                      //         context),
                                      //     SizedBox(width: 10),
                                      //     imageTitle(
                                      //         'https://preview.redd.it/daily-character-discussion-kita-ikuyo-v0-alckatsavcia1.png?width=736&format=png&auto=webp&s=3965d7e5b686028b7e5659fc5aa3195fcfbb3628',
                                      //         context)
                                      //   ],
                                      // )),
                                      Expanded(
                                          child: Row(
                                        children: [
                                          imageTitle(
                                              personGroups.isNotEmpty
                                                  ? personGroups[0]
                                                  : null,
                                              context),
                                          SizedBox(width: 10),
                                          imageTitle(
                                              personGroups.isNotEmpty &&
                                                      personGroups.length > 1
                                                  ? personGroups[1]
                                                  : null,
                                              context)
                                        ],
                                      )),
                                      SizedBox(height: 10),
                                      Expanded(
                                          child: Row(
                                        children: [
                                          imageTitle(
                                              personGroups.isNotEmpty &&
                                                      personGroups.length > 2
                                                  ? personGroups[2]
                                                  : null,
                                              context),
                                          SizedBox(width: 10),
                                          imageTitle(
                                              personGroups.isNotEmpty &&
                                                      personGroups.length > 3
                                                  ? personGroups[3]
                                                  : null,
                                              context)
                                        ],
                                      )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'People',
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            '${personGroups.length}',
                            style: TextStyle(
                              fontSize: 10,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Material(
                            borderRadius: BorderRadius.circular(20),
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerLow,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {},
                              splashColor: Colors.black12,
                              child: Container(
                                height: 172,
                                width: 172,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(14),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            imageTitle(null, context),
                                            SizedBox(width: 10),
                                            imageTitle(null, context),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Expanded(
                                        child: Row(
                                          children: [
                                            imageTitle(null, context),
                                            SizedBox(width: 10),
                                            imageTitle(null, context),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Place',
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            '12',
                            style: TextStyle(
                              fontSize: 10,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
