import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_thesis_front_end/core/usecase/usecase.dart';
import 'package:graduation_thesis_front_end/features/explore_people/domain/entities/person_group.dart';
import 'package:graduation_thesis_front_end/features/explore_people/domain/usecase/change_person_group_name.dart';
import 'package:graduation_thesis_front_end/features/explore_people/domain/usecase/get_people_group.dart';

part 'person_group_event.dart';
part 'person_group_state.dart';

class PersonGroupBloc extends Bloc<PersonGroupEvent, PersonGroupState> {
  final GetPeopleGroup _getPeopleGroup;
  final ChangePersonGroupName _changePersonGroupName;

  PersonGroupBloc(
      {required GetPeopleGroup getPeopleGroup,
      required ChangePersonGroupName changePersonGroupName})
      : _getPeopleGroup = getPeopleGroup,
        _changePersonGroupName = changePersonGroupName,
        super(PersonGroupInitial()) {
    on<PersonGroupEvent>((event, emit) {});

    on<PersonGroupFetch>(_onPersonGroupFetch);

    on<PersonGroupSetSuccuess>(_onPersonGroupSetSuccuess);

    on<ChangeGroupNameEvent>(_onChangePersonGroupName);
  }

  void _onPersonGroupFetch(
    PersonGroupFetch event,
    Emitter<PersonGroupState> emit,
  ) async {
    emit(PersonGroupLoading());
    // NOTE: dev process
    // final result = await _getPeopleGroup(NoParams());
    // result.fold(
    //   (failure) => emit(PersonGroupFailure(message: failure.message)),
    //   (personGroups) => emit(PersonGroupSuccess(personGroups: personGroups)),
    // );

    emit(PersonGroupSuccess(personGroups: []));
  }

  void _onPersonGroupSetSuccuess(
    PersonGroupSetSuccuess event,
    Emitter<PersonGroupState> emit,
  ) {
    emit(PersonGroupSuccess(personGroups: event.personGroups));
  }

  void _onChangePersonGroupName(
    ChangeGroupNameEvent event,
    Emitter<PersonGroupState> emit,
  ) async {
    emit(ChangeGroupNameLoading());
    final res = await _changePersonGroupName(
      ChangePersonGroupNameParams(
        clusterId: event.clusterId,
        newName: event.newName,
      ),
    );

    res.fold((l) => ChangeGroupNameFailure(message: l.message), (r) {
      final personGroups = event.personGroups;
      final newPersonGroups = personGroups
          .map((personGroup) => personGroup.clusterId == event.clusterId
              ? personGroup.copyWith(name: event.newName)
              : personGroup)
          .toList();
      emit(ChangeGroupNameSuccess(
          clusterId: event.clusterId,
          newName: event.newName,
          personGroups: newPersonGroups));
    });
  }
}
