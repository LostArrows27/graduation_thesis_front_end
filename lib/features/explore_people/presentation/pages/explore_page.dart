import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_thesis_front_end/core/common/layout/home_body_layout.dart';
import 'package:graduation_thesis_front_end/core/routes/routes.dart';
import 'package:graduation_thesis_front_end/core/utils/get_color_scheme.dart';
import 'package:graduation_thesis_front_end/features/explore_people/presentation/widgets/people_list.dart';
import 'package:graduation_thesis_front_end/features/explore_people/presentation/widgets/place_list.dart';
import 'package:graduation_thesis_front_end/features/explore_people/presentation/widgets/smart_tag_list.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

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
            SmartTagList(),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Memory',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    context.push(Routes.videoRenderStatusPage);
                  },
                  child: SizedBox(
                    width: double.infinity,
                    height: 200,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: WaveWidget(
                        waveFrequency: 0.8,
                        backgroundColor: Colors.blue[600],
                        config: CustomConfig(
                          colors: [
                            Colors.white70,
                            Colors.white54,
                            Colors.white30,
                            Colors.white24,
                          ],
                          durations: [32000, 21000, 18000, 5000],
                          heightPercentages: [0.25, 0.26, 0.28, 0.31],
                        ),
                        size: Size(double.infinity, double.infinity),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                    child: Center(
                        child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      'View your recap 🎬',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: getColorScheme(context).primary),
                    )
                  ],
                ))),
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
