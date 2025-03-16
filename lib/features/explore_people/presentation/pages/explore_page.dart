import 'package:flutter/material.dart';
import 'package:graduation_thesis_front_end/features/explore_people/presentation/widgets/people_list.dart';
import 'package:graduation_thesis_front_end/features/explore_people/presentation/widgets/place_list.dart';
import 'package:graduation_thesis_front_end/features/explore_people/presentation/widgets/smart_tag_list.dart';

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
  @override
  Widget build(BuildContext context) {
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
              children: [PeopleList(), PlaceList()],
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Smart Tags',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            SmartTagList()
          ],
        ),
      ),
    );
  }
}
