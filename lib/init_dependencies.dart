import 'package:get_it/get_it.dart';
import 'package:graduation_thesis_front_end/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:graduation_thesis_front_end/core/secret/app_secret.dart';
import 'package:graduation_thesis_front_end/features/album/data/datasource/album_remote_datasource.dart';
import 'package:graduation_thesis_front_end/features/album/data/repositories/album_repository_impl.dart';
import 'package:graduation_thesis_front_end/features/album/domain/repositories/album_repository.dart';
import 'package:graduation_thesis_front_end/features/album/domain/usecases/create_album.dart';
import 'package:graduation_thesis_front_end/features/album/domain/usecases/get_all_album.dart';
import 'package:graduation_thesis_front_end/features/album/presentation/bloc/album/album_bloc.dart';
import 'package:graduation_thesis_front_end/features/album/presentation/bloc/album_list/album_list_bloc.dart';
import 'package:graduation_thesis_front_end/features/album/presentation/bloc/cubit/choose_image_mode_cubit.dart';
import 'package:graduation_thesis_front_end/features/auth/data/datasource/python/image_label_remote_datasource.dart';
import 'package:graduation_thesis_front_end/features/auth/data/datasource/supabase/auth_remote_datasource.dart';
import 'package:graduation_thesis_front_end/features/auth/data/datasource/supabase/image_remote_datasource.dart';
import 'package:graduation_thesis_front_end/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:graduation_thesis_front_end/features/auth/domain/repositories/auth_repository.dart';
import 'package:graduation_thesis_front_end/features/auth/domain/usecases/current_user.dart';
import 'package:graduation_thesis_front_end/features/auth/domain/usecases/mark_user_done_labeling.dart';
import 'package:graduation_thesis_front_end/features/auth/domain/usecases/update_user_avatar.dart';
import 'package:graduation_thesis_front_end/features/auth/domain/usecases/update_user_dob_name.dart';
import 'package:graduation_thesis_front_end/features/auth/domain/usecases/update_user_survey_answer.dart';
import 'package:graduation_thesis_front_end/features/auth/domain/usecases/upload_and_get_image_label.dart';
import 'package:graduation_thesis_front_end/features/auth/domain/usecases/user_login.dart';
import 'package:graduation_thesis_front_end/features/auth/domain/usecases/user_sign_out.dart';
import 'package:graduation_thesis_front_end/features/auth/domain/usecases/user_sign_up.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:graduation_thesis_front_end/features/explore_people/data/datasource/people_category_remote_datasource.dart';
import 'package:graduation_thesis_front_end/features/explore_people/data/datasource/person_group_remote_datasource.dart';
import 'package:graduation_thesis_front_end/features/explore_people/data/repositories/explore_repository_impl.dart';
import 'package:graduation_thesis_front_end/features/explore_people/domain/repositories/explore_repository.dart';
import 'package:graduation_thesis_front_end/features/explore_people/domain/usecase/change_person_group_name.dart';
import 'package:graduation_thesis_front_end/features/explore_people/domain/usecase/get_people_group.dart';
import 'package:graduation_thesis_front_end/features/explore_people/presentation/bloc/person_group/person_group_bloc.dart';
import 'package:graduation_thesis_front_end/features/photo/data/datasource/photo_remote_datasource.dart';
import 'package:graduation_thesis_front_end/features/photo/data/repository/photo_repository_impl.dart';
import 'package:graduation_thesis_front_end/features/photo/domain/repository/photo_repository.dart';
import 'package:graduation_thesis_front_end/features/photo/domain/usecases/edit_image_caption.dart';
import 'package:graduation_thesis_front_end/features/photo/domain/usecases/get_all_user_image.dart';
import 'package:graduation_thesis_front_end/features/photo/domain/usecases/upload_images.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/bloc/cubit/photo_view_mode_cubit.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/bloc/edit_caption/edit_caption_bloc.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/bloc/photo/photo_bloc.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/bloc/upload_photo/bloc/upload_photo_bloc.dart';
import 'package:graduation_thesis_front_end/features/search/data/datasource/search_history_remote_datasource.dart';
import 'package:graduation_thesis_front_end/features/search/data/datasource/search_history_supabase_datasource.dart';
import 'package:graduation_thesis_front_end/features/search/data/repositories/search_repository_impl.dart';
import 'package:graduation_thesis_front_end/features/search/domain/repositories/search_repository.dart';
import 'package:graduation_thesis_front_end/features/search/domain/usecases/add_search_history.dart';
import 'package:graduation_thesis_front_end/features/search/domain/usecases/delete_search_history.dart';
import 'package:graduation_thesis_front_end/features/search/domain/usecases/get_all_search_history.dart';
import 'package:graduation_thesis_front_end/features/search/domain/usecases/query_image_by_text.dart';
import 'package:graduation_thesis_front_end/features/search/presentation/bloc/bloc/search_history_listen_bloc.dart';
import 'package:graduation_thesis_front_end/features/search/presentation/bloc/search_history/search_history_bloc.dart';
import 'package:graduation_thesis_front_end/features/video_render/data/datasource/video_render_datasource.dart';
import 'package:graduation_thesis_front_end/features/video_render/data/datasource/video_render_remote_datasource.dart';
import 'package:graduation_thesis_front_end/features/video_render/data/repositories/video_render_repository_impl.dart';
import 'package:graduation_thesis_front_end/features/video_render/domain/repositories/video_render_repository.dart';
import 'package:graduation_thesis_front_end/features/video_render/domain/usecase/edit_video_schema.dart';
import 'package:graduation_thesis_front_end/features/video_render/domain/usecase/get_all_video_chunk.dart';
import 'package:graduation_thesis_front_end/features/video_render/domain/usecase/get_all_video_render.dart';
import 'package:graduation_thesis_front_end/features/video_render/domain/usecase/get_video_schema.dart';
import 'package:graduation_thesis_front_end/features/video_render/presentation/bloc/edit_video_schema/edit_video_schema_bloc.dart';
import 'package:graduation_thesis_front_end/features/video_render/presentation/bloc/render_status/render_status_bloc.dart';
import 'package:graduation_thesis_front_end/features/video_render/presentation/bloc/video_chunk/video_chunk_bloc.dart';
import 'package:graduation_thesis_front_end/features/video_render/presentation/bloc/video_render_progress.dart/video_render_progress_bloc.dart';
import 'package:graduation_thesis_front_end/features/video_render/presentation/bloc/video_render_schema/video_render_schema_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'init_dependencies.main.dart';
