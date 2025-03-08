import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_thesis_front_end/core/utils/show_snackbar.dart';
import 'package:graduation_thesis_front_end/features/explore_people/presentation/bloc/person_group/person_group_bloc.dart';

Future<void> openNameEditModal(
    BuildContext context, String initialText, int clusterId) async {
  TextEditingController controller = TextEditingController(text: initialText.contains('Person') || initialText.contains('Noise') ? null : initialText);

  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return BlocConsumer<PersonGroupBloc, PersonGroupState>(
        listener: (context, state) {
          if (state is ChangeGroupNameFailure) {
            showErrorSnackBar(context, state.message);
          }

          if (state is ChangeGroupNameSuccess) {
            Navigator.of(context).pop();
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
                          'Name',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          enabled:
                              state is ChangeGroupNameLoading ? false : true,
                          autofocus: true,
                          controller: controller,
                          decoration: InputDecoration(
                            hintText: 'Enter a name',
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
                                onPressed: state is ChangeGroupNameLoading
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
                                        state is ChangeGroupNameLoading
                                    ? null
                                    : () {
                                        String updatedName = controller.text;

                                        if (updatedName == initialText) {
                                          Navigator.of(context).pop();
                                          return;
                                        }

                                        if (state is PersonGroupSuccess) {
                                          return context
                                              .read<PersonGroupBloc>()
                                              .add(
                                                ChangeGroupNameEvent(
                                                  clusterId: clusterId,
                                                  newName: updatedName,
                                                  personGroups:
                                                      state.personGroups,
                                                ),
                                              );
                                        }

                                        if (state is ChangeGroupNameSuccess) {
                                          return context
                                              .read<PersonGroupBloc>()
                                              .add(
                                                ChangeGroupNameEvent(
                                                  clusterId: clusterId,
                                                  newName: updatedName,
                                                  personGroups:
                                                      state.personGroups,
                                                ),
                                              );
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
