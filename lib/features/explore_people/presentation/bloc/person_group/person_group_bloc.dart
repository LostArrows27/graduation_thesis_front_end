import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_thesis_front_end/features/explore_people/domain/entities/person_group.dart';
import 'package:graduation_thesis_front_end/features/explore_people/domain/usecase/change_person_group_name.dart';
import 'package:graduation_thesis_front_end/features/explore_people/domain/usecase/get_people_group.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/bloc/photo/photo_bloc.dart';

part 'person_group_event.dart';
part 'person_group_state.dart';

class PersonGroupBloc extends Bloc<PersonGroupEvent, PersonGroupState> {
  final GetPeopleGroup _getPeopleGroup;
  final PhotoBloc _photoBloc;
  final ChangePersonGroupName _changePersonGroupName;
  late final StreamSubscription<PhotoState> _photoSubscription;

  PersonGroupBloc(
      {required GetPeopleGroup getPeopleGroup,
      required PhotoBloc photoBloc,
      required ChangePersonGroupName changePersonGroupName})
      : _getPeopleGroup = getPeopleGroup,
        _changePersonGroupName = changePersonGroupName,
        _photoBloc = photoBloc,
        super(PersonGroupInitial()) {
    on<PersonGroupEvent>((event, emit) {});

    on<PersonGroupFetch>(_onPersonGroupFetch);

    on<PersonGroupSetSuccuess>(_onPersonGroupSetSuccuess);

    on<ChangeGroupNameEvent>(_onChangePersonGroupName);

    on<ReloadPersonGroup>(_onReloadPersonGroup);

    _photoSubscription = _photoBloc.stream.listen((photoState) {
      if (photoState is PhotoFetchSuccess) {
        add(ReloadPersonGroup());
      }
    });
  }

  void _onReloadPersonGroup(
    ReloadPersonGroup event,
    Emitter<PersonGroupState> emit,
  ) {
    if (state is! PersonGroupSuccess && state is! ChangeGroupNameSuccess) {
      return;
    }

    List<PersonGroup> personGroup = [];

    if (state is PersonGroupSuccess) {
      personGroup = (state as PersonGroupSuccess).personGroups;
    } else if (state is ChangeGroupNameSuccess) {
      personGroup = (state as ChangeGroupNameSuccess).personGroups;
    }

    final photoList = (_photoBloc.state as PhotoFetchSuccess).photos;

    final photoIds = photoList.map((photo) => photo.id).toSet();

    final updatedPersonGroups = personGroup.map((group) {
      final updatedFaces =
          group.faces.where((face) => photoIds.contains(face.imageId)).toList();

      return group.copyWith(faces: updatedFaces);
    }).toList();

    final filteredPersonGroups =
        updatedPersonGroups.where((group) => group.faces.isNotEmpty).toList();

    emit(PersonGroupSuccess(personGroups: filteredPersonGroups));
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
    //   (personGroups) {
    //     emit(PersonGroupSuccess(personGroups: personGroups));
    //   },
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

  @override
  Future<void> close() {
    _photoSubscription.cancel();
    return super.close();
  }
}
