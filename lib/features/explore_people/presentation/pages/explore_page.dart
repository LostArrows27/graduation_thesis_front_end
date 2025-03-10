import 'package:flutter/material.dart';
import 'package:graduation_thesis_front_end/core/common/layout/home_body_layout.dart';
import 'package:graduation_thesis_front_end/features/explore_people/presentation/widgets/image_tile.dart';
import 'package:graduation_thesis_front_end/features/explore_people/presentation/widgets/people_list.dart';
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
    return BodyLayout(
        body: SingleChildScrollView(
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
                PeopleList(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Material(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).colorScheme.surfaceContainerLow,
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
                // TextButton.icon(
                //   label: Row(
                //     children: [
                //       Text(
                //         'View All',
                //         style: TextStyle(
                //             color: Theme.of(context).colorScheme.outline),
                //       ),
                //       SizedBox(width: 4),
                //       Icon(
                //         Icons.arrow_forward_ios,
                //         size: 14,
                //         color: Theme.of(context).colorScheme.outline,
                //       )
                //     ],
                //   ),
                //   onPressed: () {},
                // )
              ],
            ),
            SizedBox(height: 20),
            SmartTagList()
          ],
        ),
      ),
    ));
  }
}
