import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_thesis_front_end/features/photo/domain/usecases/edit_image_caption.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/bloc/photo/photo_bloc.dart';

part 'edit_caption_event.dart';
part 'edit_caption_state.dart';

class EditCaptionBloc extends Bloc<EditCaptionEvent, EditCaptionState> {
  final PhotoBloc _photoBloc;
  final EditImageCaption _editImageCaption;

  EditCaptionBloc({
    required PhotoBloc photoBloc,
    required EditImageCaption editImageCaption,
  })  : _photoBloc = photoBloc,
        _editImageCaption = editImageCaption,
        super(EditCaptionInitial()) {
    on<EditCaptionEvent>((event, emit) {});

    on<ChangeCaptionEvent>(_onChangeCaption);

    on<EditCaptionClear>((event, emit) {
      emit(EditCaptionInitial());
    });
  }

  void _onChangeCaption(
    ChangeCaptionEvent event,
    Emitter<EditCaptionState> emit,
  ) async {
    emit(EditCaptionLoading());
    final result = await _editImageCaption(EditImageCaptionParams(
      caption: event.caption,
      imageId: event.imageId,
    ));
    result.fold(
      (l) => emit(EditCaptionFailure(message: l.message)),
      (imageId) {
        if (_photoBloc.state is PhotoFetchSuccess) {
          emit(EditCaptionSuccess(caption: event.caption, imageId: imageId));
          _photoBloc.add(PhotoEditCaptionEvent(
              caption: event.caption, imageId: event.imageId));
        }
      },
    );
  }
}
