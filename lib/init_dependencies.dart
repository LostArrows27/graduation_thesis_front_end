import 'package:get_it/get_it.dart';
import 'package:graduation_thesis_front_end/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:graduation_thesis_front_end/core/secret/app_secret.dart';
import 'package:graduation_thesis_front_end/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:graduation_thesis_front_end/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:graduation_thesis_front_end/features/auth/domain/repositories/auth_repository.dart';
import 'package:graduation_thesis_front_end/features/auth/domain/usecases/current_user.dart';
import 'package:graduation_thesis_front_end/features/auth/domain/usecases/update_user_avatar.dart';
import 'package:graduation_thesis_front_end/features/auth/domain/usecases/user_login.dart';
import 'package:graduation_thesis_front_end/features/auth/domain/usecases/user_sign_out.dart';
import 'package:graduation_thesis_front_end/features/auth/domain/usecases/user_sign_up.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/pages/basic-information/upload_avatar_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'init_dependencies.main.dart';
