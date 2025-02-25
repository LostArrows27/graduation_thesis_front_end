import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/bloc/photo/photo_bloc.dart';
import 'package:graduation_thesis_front_end/features/video_render/presentation/pages/video_image_picker_page.dart';
import 'package:graduation_thesis_front_end/features/video_render/presentation/widgets/browse_online_gallery_header.dart';
import 'package:graduation_thesis_front_end/features/video_render/presentation/widgets/online_image_browse.dart';
import 'package:provider/provider.dart';

void showBrowseOnlineGalleryModal(
  BuildContext context,
) {
  const modalHeightSize = 0.78;
  const modalMaxHeightSize = 0.8;

  final imageProvider = Provider.of<ImageProviderModel>(context, listen: false);

  showModalBottomSheet(
    backgroundColor: Colors.white,
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    clipBehavior: Clip.antiAlias,
    isScrollControlled: true,
    builder: (context) {
      return DraggableScrollableSheet(
          initialChildSize: modalHeightSize,
          minChildSize: modalHeightSize,
          maxChildSize: modalMaxHeightSize,
          expand: false,
          builder: (context, scrollController) {
            return BlocBuilder<PhotoBloc, PhotoState>(
              builder: (context, state) {
                if (state is PhotoFetchLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  );
                }

                if (state is! PhotoFetchSuccess) {
                  return Center(
                    child: Text('Error happended'),
                  );
                }

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
                          height: MediaQuery.of(context).size.height *
                              modalHeightSize,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Expanded(
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      BrowseOnlineGalleryHeader(),
                                      SizedBox(height: 20),
                                      OnlineImageBrowse(
                                        imageProvider: imageProvider,
                                        scrollController: scrollController,
                                        photos: state.photos,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ))
                    ],
                  ),
                );
              },
            );
          });
    },
  );
}
