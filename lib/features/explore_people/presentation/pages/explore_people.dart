import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_thesis_front_end/core/common/widgets/failure.dart';
import 'package:graduation_thesis_front_end/core/utils/show_snackbar.dart';
import 'package:provider/provider.dart';

import 'package:graduation_thesis_front_end/core/common/widgets/loader.dart';
import 'package:graduation_thesis_front_end/core/routes/routes.dart';
import 'package:graduation_thesis_front_end/core/utils/convert_name.dart';
import 'package:graduation_thesis_front_end/features/explore_people/domain/entities/person_group.dart';
import 'package:graduation_thesis_front_end/features/explore_people/presentation/bloc/person_group/person_group_bloc.dart';
import 'package:graduation_thesis_front_end/features/explore_people/presentation/widgets/cropped_image.dart';

class ExplorePeoplePage extends StatelessWidget {
  final List<PersonGroup> peopleList;

  const ExplorePeoplePage({super.key, required this.peopleList});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => PersonGroupModel(personGroup: peopleList),
        child: ExplorePeopleBody());
  }
}

class ExplorePeopleBody extends StatefulWidget {
  const ExplorePeopleBody({
    super.key,
  });

  @override
  State<ExplorePeopleBody> createState() => _ExplorePeopleBodyState();
}

class _ExplorePeopleBodyState extends State<ExplorePeopleBody> {
  @override
  void initState() {
    super.initState();
    final personGroup =
        Provider.of<PersonGroupModel>(context, listen: false).getPersonGroup;

    context
        .read<PersonGroupBloc>()
        .add(PersonGroupSetSuccuess(personGroups: personGroup));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PersonGroupBloc, PersonGroupState>(
      listener: (context, state) {
        if (state is PersonGroupFailure) {
          return showErrorSnackBar(context, state.message);
        }

        if (state is PersonGroupSuccess) {
          return Provider.of<PersonGroupModel>(context, listen: false)
              .setPersonGroup(state.personGroups);
        }

        if (state is ChangeGroupNameSuccess) {
          return Provider.of<PersonGroupModel>(context, listen: false)
              .setPersonGroup(state.personGroups);
        }
      },
      builder: (context, state) {
        return Consumer<PersonGroupModel>(
            builder: (context, personGroupProvider, _) => Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  title: Text(
                    'People',
                    style: TextStyle(fontSize: 20),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.refresh),
                      onPressed: () {
                        context.read<PersonGroupBloc>().add(PersonGroupFetch());
                      },
                    )
                  ],
                ),
                body: state is PersonGroupLoading || state is PersonGroupInitial
                    ? Loader()
                    : state is PersonGroupFailure
                        ? FailureWidget(message: 'Failed to fetch people data.')
                        : Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: GridView.builder(
                                scrollDirection: Axis.vertical,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 30,
                                  childAspectRatio: 0.71,
                                ),
                                itemCount:
                                    personGroupProvider.getPersonGroup.length,
                                itemBuilder: (context, index) {
                                  final personGroup =
                                      personGroupProvider.getPersonGroup[index];
                                  final faceImage =
                                      personGroup.faces[0].imageUrl;
                                  final personCount = personGroup.faces.length;
                                  final [top, right, bottom, left] = personGroup
                                      .faces[0].coordinate
                                      .map((e) => e.toDouble())
                                      .toList();

                                  return GestureDetector(
                                    onTap: () {
                                      context.push(Routes.peopleDetailPage,
                                          extra: personGroup);
                                    },
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          width: 110,
                                          height: 110,
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(80),
                                              child: CroppedImageWidget(
                                                  imageUrl: faceImage,
                                                  boundingBox: Rect.fromLTRB(
                                                      left,
                                                      top,
                                                      right,
                                                      bottom))),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          convertName(personGroup.name),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          '$personCount',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .outline,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                          )));
      },
    );
  }
}

class PersonGroupModel extends ChangeNotifier {
  List<PersonGroup> personGroup = [];
  PersonGroupModel({
    required this.personGroup,
  });

  List<PersonGroup> get getPersonGroup => personGroup;

  void setPersonGroup(List<PersonGroup> personGroup) {
    this.personGroup = personGroup;
    notifyListeners();
  }
}
