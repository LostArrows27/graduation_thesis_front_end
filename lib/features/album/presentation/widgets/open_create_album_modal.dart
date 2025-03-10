import 'package:flutter/material.dart';
import 'package:graduation_thesis_front_end/features/album/presentation/widgets/open_choose_image_album_modal.dart';

Future<void> openCreateAlbumModal(BuildContext context) async {
  TextEditingController controller = TextEditingController(text: null);

  return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            bool isSaveEnabled = controller.text.trim().isNotEmpty;

            controller.addListener(() {
              setState(() {
                isSaveEnabled = controller.text.trim().isNotEmpty;
              });
            });

            return Dialog(
              insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
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
                        'New album',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        enabled: true,
                        autofocus: true,
                        controller: controller,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(
                              color: Theme.of(context).colorScheme.outline),
                          hintText: 'Enter an album name',
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
                              onPressed: () {
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
                              onPressed: () {
                                String updatedName = controller.text;
                                Navigator.of(context).pop();
                                openChooseImageAlbumModal(context, updatedName);
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
      });
}
