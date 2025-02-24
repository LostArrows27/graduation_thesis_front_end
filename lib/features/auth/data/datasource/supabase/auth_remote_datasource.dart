import 'dart:io';

import 'package:graduation_thesis_front_end/core/error/server_exception.dart';
import 'package:graduation_thesis_front_end/features/auth/data/model/user_model.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Session? get currentUserSession;

  Future<UserModel> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<UserModel> loginWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<UserModel?> getCurrentUserData();

  Future<String> uploadAvatarImage(
      {required File image, required UserModel userModel});

  Future<UserModel> updateUserProfileAvatar({
    required UserModel userModel,
    required String avatarUrl,
  });

  Future<UserModel> updateUserDobAndName({
    required UserModel userModel,
    required String dob,
    required String name,
  });

  Future<UserModel> updateUserSurveyAnswers({
    required UserModel userModel,
    required List<String> answers,
  });

  Future<UserModel> markUserDoneLabeling({required UserModel userModel});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl(this.supabaseClient);

  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  @override
  Future<UserModel> loginWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final response = await supabaseClient.auth
          .signInWithPassword(password: password, email: email);

      if (response.user == null) {
        throw const ServerException('User is null');
      }

      return UserModel.fromJSON(response.user!.toJson());
    } on AuthException catch (e, c) {
      print(e);
      print(c);
      throw ServerException('Invalid email or password.');
    } catch (e, c) {
      print(e);
      print(c);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmailAndPassword(
      {required String name,
      required String email,
      required String password}) async {
    try {
      final response = await supabaseClient.auth
          .signUp(password: password, email: email, data: {'name': name});

      if (response.user == null) {
        throw const ServerException('User is null');
      }

      return UserModel.fromJSON(response.user!.toJson());
    } on AuthException catch (e, c) {
      print(e);
      print(c);
      throw ServerException(e.message);
    } catch (e, c) {
      print(e);
      print(c);
      throw ServerException('Sign up failed, please try again later.');
    }
  }

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (currentUserSession == null) return null;

      final userData = await supabaseClient
          .from('user')
          .select()
          .eq('id', currentUserSession!.user.id)
          .single();

      return UserModel.fromJSON(userData);
    } catch (e, c) {
      print(e);
      print(c);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await supabaseClient.auth.signOut();
    } catch (e, c) {
      print(e);
      print(c);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> uploadAvatarImage(
      {required File image, required UserModel userModel}) async {
    try {
      String imagePath =
          '/${userModel.id}/${DateFormat('yyyy_MM_dd_HH:mm:ss').format(DateTime.now())}';

      await supabaseClient.storage
          .from('user_profile')
          .upload(imagePath, image);

      return supabaseClient.storage
          .from('user_profile')
          .getPublicUrl(imagePath);
    } catch (e, c) {
      print('Error uploading image');
      print(e);
      print(c);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> updateUserProfileAvatar(
      {required UserModel userModel, required String avatarUrl}) async {
    try {
      final res = await supabaseClient
          .from('user')
          .update({'avatar_url': avatarUrl})
          .eq('id', userModel.id)
          .select()
          .single();

      return UserModel.fromJSON(res);
    } catch (e, c) {
      print('Error updating user avatar');
      print(e);
      print(c);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> updateUserDobAndName(
      {required UserModel userModel,
      required String dob,
      required String name}) async {
    try {
      final res = await supabaseClient
          .from('user')
          .update({
            'dob': DateFormat('dd/MM/yyyy').parseStrict(dob).toIso8601String(),
            'name': name
          })
          .eq('id', userModel.id)
          .select()
          .single();

      return UserModel.fromJSON(res);
    } catch (e, c) {
      print(e);
      print(c);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> updateUserSurveyAnswers(
      {required UserModel userModel, required List<String> answers}) async {
    try {
      final res = await supabaseClient
          .from('user')
          .update({
            'survey_answers': answers,
          })
          .eq('id', userModel.id)
          .select()
          .single();

      return UserModel.fromJSON(res);
    } catch (e, c) {
      print(e);
      print(c);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> markUserDoneLabeling({required UserModel userModel}) async {
    try {
      final res = await supabaseClient
          .from('user')
          .update({
            'is_done_label_form': true,
          })
          .eq('id', userModel.id)
          .select()
          .single();

      return UserModel.fromJSON(res);
    } catch (e, c) {
      print(e);
      print(c);
      throw ServerException(e.toString());
    }
  }
}
