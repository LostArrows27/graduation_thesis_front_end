import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_thesis_front_end/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:graduation_thesis_front_end/core/utils/show_snackbar.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/pages/basic-information/upload_image_label_page.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/widgets/complete_stage_bar.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/widgets/lottie_answer.dart';

class SurveyFormPage extends StatefulWidget {
  const SurveyFormPage({super.key});

  static const path = '/information/survey-form';

  @override
  State<SurveyFormPage> createState() => _SurveyFormPageState();
}

class _SurveyFormPageState extends State<SurveyFormPage> {
  List<String>? answers;

  void onAnswered(String answer) {
    setState(() {
      if (answers == null || answers!.isEmpty) {
        answers = [answer];
      } else if (answers!.contains(answer)) {
        answers!.remove(answer);
        if (answers!.isEmpty) {
          answers = null;
        }
      } else {
        answers!.add(answer);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      buildWhen: (previous, current) =>
          current is AuthUpdateSurveyLoading || current is AuthUpdateSurvey,
      listener: (context, state) {
        if (state is AuthUpdateSurveySuccess) {
          context.go(UploadImageLabel.path);
        }

        if (state is AuthUpdateSurveyFailure) {
          showSnackBar(context, 'Upload failed. Please try again.');
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                SizedBox(height: 90),
                Center(
                    child: Text(
                  "What You Like To Organize Your Image By?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                )),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 40),
                        LottieAnswer(
                            assetPath: 'assets/lottie/album.json',
                            onAnswered: state is AuthUpdateSurveyLoading
                                ? null
                                : onAnswered,
                            height: 150,
                            description:
                                'Organize your photos by events and special occasions.',
                            answer: 'Event and Holiday'),
                        SizedBox(height: 16),
                        LottieAnswer(
                            assetPath: 'assets/lottie/person.json',
                            onAnswered: state is AuthUpdateSurveyLoading
                                ? null
                                : onAnswered,
                            height: 80,
                            description:
                                'Group your photos with your friend, family and loved ones.',
                            answer: 'Friend and Family'),
                        SizedBox(height: 16),
                        LottieAnswer(
                            assetPath: 'assets/lottie/activity.json',
                            onAnswered: state is AuthUpdateSurveyLoading
                                ? null
                                : onAnswered,
                            height: 150,
                            description:
                                'Create moment from your activity and passion.',
                            answer: 'Activity and Hobby'),
                        SizedBox(height: 16),
                        LottieAnswer(
                            assetPath: 'assets/lottie/location.json',
                            onAnswered: state is AuthUpdateSurveyLoading
                                ? null
                                : onAnswered,
                            height: 150,
                            description:
                                'Sort your photos by location or places you visited',
                            answer: 'Location and Place'),
                        SizedBox(height: 16),
                        LottieAnswer(
                            assetPath: 'assets/lottie/video.json',
                            onAnswered: state is AuthUpdateSurveyLoading
                                ? null
                                : onAnswered,
                            height: 150,
                            description:
                                'Create a recap video of your favorite moments.',
                            answer: 'Recap Video'),
                        SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomAppBar(
              padding: EdgeInsets.all(0),
              color: Theme.of(context).scaffoldBackgroundColor,
              height: 100,
              child: Column(
                children: [
                  CompleteStageBar(currentStep: 3),
                  SizedBox(height: 26),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton.outlined(
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.all(14),
                            ),
                            onPressed: answers == null ||
                                    answers!.isEmpty ||
                                    state is AuthUpdateSurveyLoading ||
                                    !Navigator.of(context).canPop()
                                ? null
                                : () {
                                    Navigator.of(context).pop();
                                  },
                            icon: Icon(
                              Icons.arrow_back,
                            )),
                        SizedBox(width: 16),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: answers == null ||
                                    answers!.isEmpty ||
                                    state is AuthUpdateSurveyLoading
                                ? null
                                : () {
                                    context.read<AuthBloc>().add(
                                        AuthUpdateUserSurveyEvent(
                                            answers: answers!,
                                            user: (context
                                                        .read<AppUserCubit>()
                                                        .state
                                                    as AppUserWithMissingSurvey)
                                                .user));
                                  },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 15),
                            ),
                            label: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Continue',
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(width: 2),
                                Icon(Icons.arrow_forward),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        );
      },
    );
  }
}
