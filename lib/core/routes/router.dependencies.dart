import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_thesis_front_end/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:graduation_thesis_front_end/core/common/entities/image.dart';
import 'package:graduation_thesis_front_end/core/common/enum/app_enum.dart';
import 'package:graduation_thesis_front_end/core/common/layout/home_scaffold_layout.dart';
import 'package:graduation_thesis_front_end/core/mock/page/album_page.dart';
import 'package:graduation_thesis_front_end/core/mock/page/photo_slider.dart';
import 'package:graduation_thesis_front_end/features/explore_people/domain/entities/person_group.dart';
import 'package:graduation_thesis_front_end/features/explore_people/presentation/pages/explore_page.dart';
import 'package:graduation_thesis_front_end/core/mock/page/search_page.dart';
import 'package:graduation_thesis_front_end/core/routes/go_router_refresh_stream.dart';
import 'package:graduation_thesis_front_end/core/routes/routes.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/pages/basic-information/confirm_done_page.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/pages/basic-information/dob_name_form_page.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/pages/basic-information/survey_form_page.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/pages/basic-information/upload_avatar_page.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/pages/basic-information/upload_image_label_page.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/pages/landing_page.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/pages/login_page.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/pages/sign_up_page.dart';
import 'package:graduation_thesis_front_end/features/explore_people/presentation/pages/explore_people.dart';
import 'package:graduation_thesis_front_end/features/explore_people/presentation/pages/people_detail.dart';
import 'package:graduation_thesis_front_end/features/explore_people/presentation/pages/smart_tag_viewer_page.dart';
import 'package:graduation_thesis_front_end/features/photo/domain/entities/album_folder.dart';
import 'package:graduation_thesis_front_end/features/photo/domain/entities/year_album_folder.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/pages/album_viewer_page.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/pages/image_slider_page.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/pages/photo_page.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/pages/upload_photo_page.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/pages/year_album_viewer_page.dart';
import 'package:graduation_thesis_front_end/features/video_render/domain/entities/video_schema.dart';
import 'package:graduation_thesis_front_end/features/video_render/presentation/pages/edit_video_schema_page.dart';
import 'package:graduation_thesis_front_end/features/video_render/presentation/pages/video_image_picker_page.dart';
import 'package:graduation_thesis_front_end/features/video_render/presentation/pages/video_render_result_page.dart';
import 'package:graduation_thesis_front_end/features/video_render/presentation/pages/video_render_status_page.dart';
import 'package:graduation_thesis_front_end/features/video_render/presentation/pages/video_viewer_page.dart';
import 'package:graduation_thesis_front_end/init_dependencies.dart';

part 'router.main.dart';
