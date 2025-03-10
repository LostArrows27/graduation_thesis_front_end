import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_thesis_front_end/core/routes/routes.dart';
import 'package:graduation_thesis_front_end/core/utils/convert_name.dart';
import 'package:graduation_thesis_front_end/core/utils/format_date.dart';
import 'package:graduation_thesis_front_end/core/utils/group_album_image.dart';
import 'package:graduation_thesis_front_end/core/utils/group_image.dart';
import 'package:graduation_thesis_front_end/features/explore_people/domain/entities/face.dart';
import 'package:graduation_thesis_front_end/features/explore_people/domain/entities/person_group.dart';
import 'package:graduation_thesis_front_end/features/explore_people/presentation/bloc/person_group/person_group_bloc.dart';
import 'package:graduation_thesis_front_end/features/explore_people/presentation/widgets/cropped_avatar.dart';
import 'package:graduation_thesis_front_end/features/explore_people/presentation/widgets/edit_name_model.dart';
import 'package:graduation_thesis_front_end/core/common/widgets/hero_network_image.dart';

class PeopleDetail extends StatefulWidget {
  final PersonGroup personGroup;

  const PeopleDetail({super.key, required this.personGroup});

  @override
  State<PeopleDetail> createState() => _PeopleDetailState();
}

class _PeopleDetailState extends State<PeopleDetail> {
  late PersonGroup _personGroup;

  @override
  void initState() {
    super.initState();
    setState(() {
      _personGroup = widget.personGroup;
    });
  }

  void _updatePersonGroup(String newName) {
    setState(() {
      _personGroup = _personGroup.copyWith(name: newName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              convertName(_personGroup.name),
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 5),
            Text(
              '${_personGroup.faces.length} items',
              style: TextStyle(
                  fontSize: 14, color: Theme.of(context).colorScheme.outline),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              // TODO: show more options
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Stack(
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: buildFaceImage(_personGroup.faces[0]),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 5),
                  BlocListener<PersonGroupBloc, PersonGroupState>(
                    listener: (context, state) {
                      if (state is ChangeGroupNameSuccess) {
                        _updatePersonGroup(state.newName);
                      }
                    },
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        minimumSize: Size(100, 36),
                      ),
                      onPressed: () async {
                        await openNameEditModal(
                            context, _personGroup.name, _personGroup.clusterId);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(convertName(_personGroup.name),
                              style: TextStyle(fontSize: 14)),
                          SizedBox(width: 10),
                          Icon(Icons.edit, size: 14)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            FaceGroupViewMode(
                groupedByDate: groupImageFaceByDate(_personGroup.faces)),
          ],
        ),
      ),
    );
  }
}

class FaceGroupViewMode extends StatelessWidget {
  final List<Map<String, dynamic>> groupedByDate;

  const FaceGroupViewMode({super.key, required this.groupedByDate});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: groupedByDate.length,
        itemBuilder: (context, index) {
          var section = groupedByDate[index];
          DateTime sectionDate = section['date'];
          String sectionTitle = formatDate(sectionDate);
          List<Face> faceList = List<Face>.from(section['faces']);

          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                  child: Text(
                    sectionTitle,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
                StaggeredGrid.count(
                  crossAxisCount: 4,
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 2,
                  children: faceList.map((face) {
                    return Padding(
                      padding: const EdgeInsets.all(0),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: GestureDetector(
                          onTap: () {
                            context.push(Routes.imageSliderPage, extra: {
                              'url': face.imageUrl,
                              'images': getAllPhotoFromFaceGroup(faceList)
                            });
                          },
                          child: HeroNetworkImage(
                            imageUrl: face.imageUrl,
                            heroTag: face.imageUrl,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        });
  }
}
