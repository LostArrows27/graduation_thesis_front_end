import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/bloc/cubit/change_album_name_cubit.dart';

Future<void> openEditAlbumNameModal(
    BuildContext context, String oldName, String albumId) async {
  TextEditingController controller = TextEditingController(text: oldName);

  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return BlocConsumer<ChangeAlbumNameCubit, ChangeAlbumNameState>(
        listener: (context, state) {
          if (state is ChangeAlbumNameSuccess) {
            return Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          return StatefulBuilder(
            builder: (context, setState) {
              bool isSaveEnabled = controller.text.trim().isNotEmpty;

              controller.addListener(() {
                setState(() {
                  isSaveEnabled = controller.text.trim().isNotEmpty;
                });
              });

              return Dialog(
                insetPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  width: 400,
                  constraints: BoxConstraints(maxWidth: 600),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'Album Name',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          enabled:
                              state is ChangeAlbumNameLoading ? false : true,
                          autofocus: true,
                          controller: controller,
                          decoration: InputDecoration(
                            hintText: 'Enter album name...',
                            border: UnderlineInputBorder(),
                            filled: true,
                            fillColor: Colors.transparent,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(12),
                                    ),
                                  ),
                                ),
                                onPressed: state is ChangeAlbumNameLoading
                                    ? null
                                    : () {
                                        Navigator.of(context).pop();
                                      },
                                child: Text('Cancel'),
                              ),
                            ),
                            VerticalDivider(
                              width: 1,
                              thickness: 1,
                              color: Colors.grey.withOpacity(0.3),
                            ),
                            Expanded(
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(12),
                                    ),
                                  ),
                                  foregroundColor: isSaveEnabled
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).disabledColor,
                                ),
                                onPressed: !isSaveEnabled ||
                                        state is ChangeAlbumNameLoading
                                    ? null
                                    : () async {
                                        String editCaption =
                                            controller.text.trim();

                                        if (editCaption == oldName ||
                                            editCaption.isEmpty) {
                                          Navigator.of(context).pop();
                                        } else {
                                          return await context
                                              .read<ChangeAlbumNameCubit>()
                                              .changeAlbumName(
                                                  albumId: albumId,
                                                  albumName: editCaption);
                                        }
                                      },
                                child: Text('Save'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    },
  );
}
