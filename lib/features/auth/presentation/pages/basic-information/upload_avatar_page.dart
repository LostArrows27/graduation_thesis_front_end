import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_thesis_front_end/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:graduation_thesis_front_end/core/routes/routes.dart';
import 'package:graduation_thesis_front_end/core/utils/pick_image.dart';
import 'package:graduation_thesis_front_end/core/utils/show_snackbar.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/widgets/complete_stage_bar.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/widgets/text_divider.dart';
import 'package:image_picker/image_picker.dart';

class UploadAvatarPage extends StatefulWidget {
  const UploadAvatarPage({super.key});

  @override
  State<UploadAvatarPage> createState() => _UploadAvatarPageState();
}

class _UploadAvatarPageState extends State<UploadAvatarPage> {
  File? image;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      buildWhen: (previous, current) =>
          current is AuthAvatarUploading || current is AuthAvatarUploadFailure,
      listener: (context, state) {
        if (state is AuthAvatarUploadSuccess) {
          context.push(Routes.dobNameFormPage);
        }

        if (state is AuthAvatarUploadFailure) {
          showSnackBar(context, 'Upload failed. Please try again.');
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(''),
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Center(
                          child: Text(
                        "Let's Set Up Your Profile Avatar or Image",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                        ),
                      )),
                      SizedBox(height: 80),
                      image == null
                          ? GestureDetector(
                              onTap: () async {
                                final result = await selectLibraryImage(
                                    ImageSource.gallery, context);
                                if (result != null) {
                                  setState(() {
                                    image = result;
                                  });
                                }
                              },
                              child: Container(
                                  width: double.infinity,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    // color: Theme.of(context).colorScheme.primaryFixedDim,
                                    border: Border.all(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      width: 4,
                                    ),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.image,
                                        size: 40,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Upload Your Image',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .outline,
                                        ),
                                      ),
                                    ],
                                  )),
                            )
                          : GestureDetector(
                              onTap: state is AuthAvatarLoading
                                  ? null
                                  : () async {
                                      final result = await selectLibraryImage(
                                          ImageSource.gallery, context);
                                      if (result != null) {
                                        setState(() {
                                          image = result;
                                        });
                                      }
                                    },
                              child: Container(
                                width: double.infinity,
                                height: 200,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    width: 4,
                                  ),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Stack(
                                    children: state is AuthAvatarLoading
                                        ? [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(21),
                                              child: ColorFiltered(
                                                colorFilter: ColorFilter.mode(
                                                  Colors.black
                                                      .withValues(alpha: 100),
                                                  BlendMode.saturation,
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(21),
                                                  child: Image.file(
                                                    image!,
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
                                          ]
                                        : [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(21),
                                              child: Image.file(
                                                image!,
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                              ),
                                            ),
                                          ]),
                              ),
                            ),
                      SizedBox(height: 40),
                      TextDivider(),
                      SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: state is AuthAvatarLoading
                              ? null
                              : () {
                                  selectLibraryImage(
                                      ImageSource.camera, context);
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primaryContainer,
                            padding: EdgeInsets.symmetric(vertical: 15),
                          ),
                          icon: Icon(Icons.camera_enhance_rounded),
                          label: Text(
                            '  Open Camera & Take Photo',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: BottomAppBar(
              padding: EdgeInsets.all(0),
              color: Theme.of(context).scaffoldBackgroundColor,
              height: 100,
              child: Column(
                children: [
                  CompleteStageBar(currentStep: 1),
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
                            onPressed: state is AuthAvatarLoading
                                ? null
                                : () {
                                    if (Navigator.canPop(context)) {
                                      Navigator.pop(context);
                                    }
                                  },
                            icon: Icon(
                              Icons.arrow_back,
                            )),
                        SizedBox(width: 16),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed:
                                image == null || state is AuthAvatarLoading
                                    ? null
                                    : () {
                                        context.read<AuthBloc>().add(
                                              AuthUploadProfilePicture(
                                                  file: image!,
                                                  user: (context
                                                              .read<AppUserCubit>()
                                                              .state
                                                          as AppUserWithMissingInfo)
                                                      .user),
                                            );
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
