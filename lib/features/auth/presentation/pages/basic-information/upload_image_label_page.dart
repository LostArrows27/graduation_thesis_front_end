import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_thesis_front_end/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:graduation_thesis_front_end/core/utils/pick_image.dart';
import 'package:graduation_thesis_front_end/core/utils/show_confetti.dart';
import 'package:graduation_thesis_front_end/core/utils/show_snackbar.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/pages/basic-information/confirm_done_page.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/widgets/complete_stage_bar.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/widgets/view_label_result_bottom_modal.dart';
import 'package:image_picker/image_picker.dart';
import 'package:graduation_thesis_front_end/core/common/entities/image.dart'
    as image;
import 'package:lottie/lottie.dart';

// NOTE: option form -> can skip
// skip -> set isDoneLabelForm = true in database
class UploadImageLabel extends StatefulWidget {
  const UploadImageLabel({super.key});

  static const path = '/information/upload-image-label';

  @override
  State<UploadImageLabel> createState() => _UploadImageLabelState();
}

class _UploadImageLabelState extends State<UploadImageLabel> {
  List<File?> imageFiles = [null, null, null];
  List<image.Image?> imagesLabel = [];

  void addImage(int index, File? image) {
    if (image == null) return;
    setState(() {
      imageFiles[index] = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUploadAndGetImageLabelFailure) {
          return showSnackBar(context, state.message);
        }

        if (state is AuthUploadAndGetImageLabelSuccess) {
          showConfetti(context);
          setState(() {
            imagesLabel = state.images;
          });
          return;
        }

        if (state is AuthMarkImageLabelFormDoneSuccess) {
          return context.go(ConfirmDonePage.path);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: Column(
              children: [
                SizedBox(height: 80),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      Text(
                        "You Are Almost Done!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 14),
                      Text(
                        "Choose 3 images that mean the most to you.\nLet's us categorize them for you !",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          height: 1.5,
                          fontSize: 15,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 70),
                CarouselSlider.builder(
                    itemCount: 3,
                    itemBuilder: (context, index, realIndex) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        height: 400,
                        child: GestureDetector(
                          onTap: () async {
                            if (state is AuthUploadAndGetImageLabelLoading ||
                                state is AuthMarkImageLabelFormDoneLoading) {
                              return;
                            }

                            if (imagesLabel.isNotEmpty) {
                              return viewLabelResultBottomModal(context,
                                  imageFiles[index]!, imagesLabel[index]!);
                            }
                            File? image = await selectLibraryImage(
                                ImageSource.gallery, context, false);

                            if (image != null) {
                              addImage(index, image);
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHigh,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryFixedDim,
                                width: 5,
                              ),
                            ),
                            child: imageFiles[index] == null
                                ? SizedBox(
                                    width: double.infinity,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(Icons.image,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primaryFixedDim,
                                            size: 50),
                                        SizedBox(height: 20),
                                        Text(
                                          "Upload your image",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primaryFixedDim,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : state is AuthUploadAndGetImageLabelLoading
                                    ? Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: ColorFiltered(
                                              colorFilter: ColorFilter.mode(
                                                Colors.black
                                                    .withValues(alpha: 100),
                                                BlendMode.saturation,
                                              ),
                                              child: ClipRRect(
                                                child: Image.file(
                                                  imageFiles[index]!,
                                                  fit: BoxFit.cover,
                                                  width: double.infinity,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: CircularProgressIndicator(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                          )
                                        ],
                                      )
                                    : imagesLabel.isNotEmpty
                                        ? Stack(
                                            fit: StackFit.expand,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                child: ColorFiltered(
                                                  colorFilter: ColorFilter.mode(
                                                    Colors.black
                                                        .withValues(alpha: 255),
                                                    BlendMode.saturation,
                                                  ),
                                                  child: Center(
                                                      child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Lottie.asset(
                                                          'assets/lottie/touch_here.json',
                                                          delegates:
                                                              LottieDelegates(
                                                            values: [
                                                              ValueDelegate
                                                                  .color(
                                                                const ['**'],
                                                                value: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .primary,
                                                              ),
                                                            ],
                                                          ),
                                                          width:
                                                              double.infinity,
                                                          height: 100),
                                                      SizedBox(height: 20),
                                                      Text(
                                                        'Tap here to view\nimage categorize result',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Stack(
                                            fit: StackFit.expand,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                child: Image.file(
                                                  imageFiles[index]!,
                                                  fit: BoxFit.cover,
                                                  width: double.infinity,
                                                ),
                                              ),
                                            ],
                                          ),
                          ),
                        ),
                      );
                    },
                    options: CarouselOptions(
                        height: 450,
                        enlargeCenterPage: true,
                        enlargeFactor: 0.25,
                        enlargeStrategy: CenterPageEnlargeStrategy.scale))
              ],
            ),
          ),
          bottomNavigationBar: BottomAppBar(
              padding: EdgeInsets.all(0),
              color: Theme.of(context).scaffoldBackgroundColor,
              height: 100,
              child: Column(
                children: [
                  CompleteStageBar(currentStep: 4),
                  SizedBox(height: 26),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: OutlinedButton.icon(
                            onPressed: state
                                        is AuthUploadAndGetImageLabelLoading ||
                                    state is AuthMarkImageLabelFormDoneLoading
                                ? null
                                : () {
                                    context.read<AuthBloc>().add(
                                        AuthMarkDoneLabelingEvent(
                                            user: (context
                                                        .read<AppUserCubit>()
                                                        .state
                                                    as AppUserWithMissingLabel)
                                                .user));
                                  },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 15),
                            ),
                            label: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Skip',
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          flex: 3,
                          child: FilledButton.icon(
                            onPressed:
                                (state is AuthUploadAndGetImageLabelLoading ||
                                            imageFiles.any((element) =>
                                                element == null)) ||
                                        state
                                            is AuthMarkImageLabelFormDoneLoading
                                    ? null
                                    : imagesLabel.isNotEmpty
                                        ? () {
                                            context.read<AuthBloc>().add(
                                                AuthMarkDoneLabelingEvent(
                                                    user: (context
                                                                .read<
                                                                    AppUserCubit>()
                                                                .state
                                                            as AppUserWithMissingLabel)
                                                        .user));
                                          }
                                        : () {
                                            if (imageFiles.every(
                                                (element) => element != null)) {
                                              context.read<AuthBloc>().add(
                                                  UploadAndGetImageLabelEvent(
                                                      files: imageFiles
                                                          .whereType<File>()
                                                          .toList(),
                                                      userId: (context
                                                                  .read<
                                                                      AppUserCubit>()
                                                                  .state
                                                              as AppUserWithMissingLabel)
                                                          .user
                                                          .id));
                                            } else {
                                              showSnackBar(context,
                                                  'Please upload all images');
                                            }
                                          },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 15),
                            ),
                            label: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  imagesLabel.isNotEmpty
                                      ? 'Continue'
                                      : 'Upload images',
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
