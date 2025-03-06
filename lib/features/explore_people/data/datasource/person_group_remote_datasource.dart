import 'package:graduation_thesis_front_end/core/error/server_exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class PersonGroupRemoteDatasource {
  Future<void> changePersonGroupName(
      {required int clusterId, required String newName});
}

class PersonGroupRemoteDatasourceImpl implements PersonGroupRemoteDatasource {
  final SupabaseClient supabaseClient;

  PersonGroupRemoteDatasourceImpl({required this.supabaseClient});

  @override
  Future<void> changePersonGroupName(
      {required int clusterId, required String newName}) async {
    try {
      await supabaseClient.from('cluster_mapping').update({
        'name': newName,
      }).eq('id', clusterId);
    } catch (e, c) {
      print(e);
      print(c);
      throw ServerException("Failed to get user images.");
    }
  }
}
