import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:graduation_thesis_front_end/core/common/constant/app_constant.dart';
import 'package:graduation_thesis_front_end/core/error/server_exception.dart';
import 'package:graduation_thesis_front_end/features/search/data/model/search_history_model.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class SearchHistoryRemoteDatasource {
  Future<SearchHistoryModel> queryImageByText({required String text});
}

class SearchHistoryRemoteDatasourceImpl
    implements SearchHistoryRemoteDatasource {
  final String endPointUrl;
  final SupabaseClient supabaseClient;

  SearchHistoryRemoteDatasourceImpl(
      {this.endPointUrl = 'http://10.0.2.2:8080/api/query-image',
      required this.supabaseClient});

  String get userId => supabaseClient.auth.currentUser!.id;

  String getImageUrl(String imageBucketId, String imageName) {
    return supabaseClient.storage.from(imageBucketId).getPublicUrl(imageName);
  }

  @override
  Future<SearchHistoryModel> queryImageByText({required String text}) async {
    try {
      final Map<String, dynamic> requestBody = {
        "user_id": userId,
        "query": text,
        "threshold": AppConstant.searchThresHold,
      };

      final http.Response response = await http.post(
        Uri.parse(endPointUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson = jsonDecode(response.body);

        if (responseJson["status"] != 'success') {
          throw ServerException("Server error: ${responseJson['message']}");
        }

        if (responseJson["status"] == "success") {
          final Map<String, dynamic> data = responseJson["data"];

          return SearchHistoryModel.fromJson(data);
        } else {
          throw ServerException("Failed to query image result.");
        }
      } else {
        throw ServerException(
            "Failed to query image result. Status code: ${response.statusCode}");
      }
    } catch (e, c) {
      print(e);
      debugPrintStack(stackTrace: c);
      throw ServerException("Failed to query image result.");
    }
  }
}
