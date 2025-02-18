import 'package:flutter/material.dart';

// TODO: implement add modal
void showAddModal(BuildContext context) {
  const modalHeightSize = 0.65;
  const modalMaxHeightSize = 0.65;

  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return DraggableScrollableSheet(
          initialChildSize: modalHeightSize,
          minChildSize: modalHeightSize,
          maxChildSize: modalMaxHeightSize,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    width: double.infinity,
                    height:
                        MediaQuery.of(context).size.height * modalHeightSize,
                  )
                ],
              ),
            );
          });
    },
  );
}
