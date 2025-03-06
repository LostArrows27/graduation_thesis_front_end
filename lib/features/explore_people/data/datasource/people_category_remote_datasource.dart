import 'dart:convert';
import 'package:graduation_thesis_front_end/core/error/server_exception.dart';
import 'package:graduation_thesis_front_end/features/explore_people/data/model/person_group_model.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class PeopleCategoryRemoteDatasource {
  Future<List<PersonGroupModel>> getPersonGroups();
}

class PeopleCategoryRemoteDatasourceImpl
    implements PeopleCategoryRemoteDatasource {
  final String endPointUrl;
  final SupabaseClient supabaseClient;

  PeopleCategoryRemoteDatasourceImpl(
      {this.endPointUrl = 'http://10.0.2.2:8080/api/person-clustering',
      required this.supabaseClient});

  String get userId => supabaseClient.auth.currentUser!.id;

  @override
  Future<List<PersonGroupModel>> getPersonGroups() async {
    try {
      final Map<String, dynamic> requestBody = {
        "user_id": userId,
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
          // data -> {status, data: {"index": personGroup }}

          final List<PersonGroupModel> personGroups = [];
          data.forEach((key, value) {
            final Map<String, dynamic> personGroupData = value;
            final personGroupEntity  = PersonGroupModel.fromJson(personGroupData);
            personGroups.add(personGroupEntity);
          });

          return personGroups;
        } else {
          throw ServerException("Failed to categorize people list.");
        }
      } else {
        throw ServerException(
            "Failed to categorize people list. Status code: ${response.statusCode}");
      }
    } catch (e, c) {
      print(e);
      print(c);
      throw ServerException("Failed to categorize people list.");
    }
  }
}
