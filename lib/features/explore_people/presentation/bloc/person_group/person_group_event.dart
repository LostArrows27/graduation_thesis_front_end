part of 'person_group_bloc.dart';

@immutable
sealed class PersonGroupEvent {}

final class PersonGroupFetch extends PersonGroupEvent {}

final class ReloadPersonGroup extends PersonGroupEvent {}

final class PersonGroupSetSuccuess extends PersonGroupEvent {
  final List<PersonGroup> personGroups;

  PersonGroupSetSuccuess({required this.personGroups});
}

final class ChangeGroupNameEvent extends PersonGroupEvent {
  final int clusterId;
  final String newName;
  final List<PersonGroup> personGroups;

  ChangeGroupNameEvent(
      {required this.clusterId,
      required this.newName,
      required this.personGroups});
}
