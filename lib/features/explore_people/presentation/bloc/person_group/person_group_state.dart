part of 'person_group_bloc.dart';

@immutable
sealed class PersonGroupState {}

final class PersonGroupInitial extends PersonGroupState {}

final class PersonGroupLoading extends PersonGroupState {}

final class PersonGroupSuccess extends PersonGroupState {
  final List<PersonGroup> personGroups;

  PersonGroupSuccess({required this.personGroups});
}

final class PersonGroupFailure extends PersonGroupState {
  final String message;

  PersonGroupFailure({required this.message});
}

// change name state
final class ChangeGroupNameInitial extends PersonGroupState {}

final class ChangeGroupNameLoading extends PersonGroupState {}

final class ChangeGroupNameSuccess extends PersonGroupState {
  final List<PersonGroup> personGroups;
  final String newName;
  final int clusterId;

  ChangeGroupNameSuccess(
      {required this.personGroups,
      required this.newName,
      required this.clusterId});
}

final class ChangeGroupNameFailure extends PersonGroupState {
  final String message;

  ChangeGroupNameFailure({required this.message});
}
