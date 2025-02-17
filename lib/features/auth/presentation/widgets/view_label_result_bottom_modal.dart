import 'dart:io';

import 'package:flutter/material.dart';
import 'package:graduation_thesis_front_end/core/common/entities/image.dart'
    as image;
import 'package:glass/glass.dart';

// 2 ways
// 1. result + image + label
// 2. folder like gallery image
void viewLabelResultBottomModal(
    BuildContext context, File imageFiles, image.Image imageLabel) {
  const modalHeightSize = 0.65;
  const modalMaxHeightSize = 0.65;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
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
                      image: DecorationImage(
                        image: FileImage(imageFiles),
                        fit: BoxFit.cover,
                      ),
                    ),
                    width: double.infinity,
                    height:
                        MediaQuery.of(context).size.height * modalHeightSize,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 290,
                          child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Category Result',
                                    style: TextStyle(
                                        fontSize: 25,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Wrap(
                                    spacing: 15, // gap between adjacent chips
                                    runSpacing: 10, // gap between Lines,
                                    children: [
                                      ...imageLabel.labels.labels.locationLabels
                                          .map(
                                        (e) => Chip(
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          label: Text(
                                            e.label,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                      ...imageLabel.labels.labels.eventLabels
                                          .map(
                                        (e) => Chip(
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          label: Text(
                                            e.label,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                      ...imageLabel.labels.labels.actionLabels
                                          .map(
                                        (e) => Chip(
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                          shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .tertiary,
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          label: Text(
                                            e.label,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              )),
                        ).asGlass(
                          tintColor: Colors.black,
                        ),
                      ],
                    )),
              ],
            ),
          );
        },
      );
    },
  );
}
