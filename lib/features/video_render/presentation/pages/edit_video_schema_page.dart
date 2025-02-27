import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_thesis_front_end/core/common/enum/app_enum.dart';
import 'package:graduation_thesis_front_end/core/routes/routes.dart';
import 'package:graduation_thesis_front_end/core/utils/convert_string_to_song.dart';
import 'package:graduation_thesis_front_end/core/utils/show_snackbar.dart';
import 'package:graduation_thesis_front_end/core/utils/string_to_season.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/widgets/text_divider.dart';
import 'package:graduation_thesis_front_end/features/video_render/domain/entities/song.dart';
import 'package:graduation_thesis_front_end/features/video_render/domain/entities/video_schema.dart';
import 'package:graduation_thesis_front_end/features/video_render/presentation/bloc/edit_video_schema/edit_video_schema_bloc.dart';
import 'package:graduation_thesis_front_end/features/video_render/presentation/widgets/edit_video_schema/music_player.dart';
import 'package:graduation_thesis_front_end/features/video_render/presentation/widgets/edit_video_schema/show_music_modal.dart';
import 'package:graduation_thesis_front_end/init_dependencies.dart';

// TODO: test to see if video is push to render queue
// TODO: redirect to video progress page
class EditVideoSchemaPage extends StatefulWidget {
  final VideoSchema videoSchema;

  const EditVideoSchemaPage({super.key, required this.videoSchema});

  @override
  State<EditVideoSchemaPage> createState() => _EditVideoSchemaPageState();
}

class _EditVideoSchemaPageState extends State<EditVideoSchemaPage> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _titleController = TextEditingController();
  final List<Map<String, dynamic>> _timeOptions = [
    {'label': 'No limit', 'value': 0},
    {'label': '1 minute', 'value': 60},
    {'label': '2 minutes', 'value': 120},
    {'label': '3 minutes', 'value': 180},
    {'label': '4 minutes', 'value': 240},
    {'label': '5 minutes', 'value': 300},
  ];

  final List<Season> seasons = [
    Season.spring,
    Season.summer,
    Season.fall,
    Season.winter
  ];

  // init state
  int _seasonStyle = 1;
  int _selectedStyle = 0;
  int _selectedTimeInSeconds = 0;
  String _scale = "1";
  Season _selectedSeason = Season.spring;
  Song? _selectedSong;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.videoSchema.videoTitle;

    final random = Random().nextInt(2) + 1;

    setState(() {
      _seasonStyle = random;
      _selectedSeason = seasonFromString(widget.videoSchema.bgVideoTheme);
      _selectedTimeInSeconds = widget.videoSchema.maxDuration ?? 0;
      _selectedStyle = widget.videoSchema.titleStyle;
      _selectedSong = convertStringToSong(widget.videoSchema.bgMusic);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });

    _titleController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void setSong(Song song) {
    setState(() {
      _selectedSong = song;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<EditVideoSchemaBloc>(),
      child: Scaffold(
          appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  context.go(Routes.videoRenderStatusPage);
                },
              ),
              actions: [
                BlocConsumer<EditVideoSchemaBloc, EditVideoSchemaState>(
                  listener: (context, state) {
                    if (state is EditVideoSchemaError) {
                      return showSnackBar(context, state.message);
                    }

                    if (state is EditVideoSchemaSuccess) {
                      context.push(Routes.videoRenderResult,
                          extra: state.videoSchema.videoRenderId);
                    }
                  },
                  builder: (context, state) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: FilledButton(
                          onPressed: state is EditVideoSchemaLoading
                              ? null
                              : () {
                                  // assets/music/emotional_1.mp3
                                  // replace assets/music with /music/intro
                                  BlocProvider.of<EditVideoSchemaBloc>(context)
                                      .add(SendEditVideoSchema(
                                          scale: _scale,
                                          videoSchema: VideoSchema(
                                              videoRenderId: widget
                                                  .videoSchema.videoRenderId,
                                              videoTitle: _titleController.text,
                                              titleStyle: _selectedStyle,
                                              maxDuration:
                                                  _selectedTimeInSeconds,
                                              bgVideoTheme:
                                                  _selectedSeason.name,
                                              bgMusic: _selectedSong!
                                                  .audioAssetPath
                                                  .replaceFirst('assets/music',
                                                      '/music/intro'),
                                              thumbnailUrl: widget
                                                  .videoSchema.thumbnailUrl)));
                                },
                          child: Text(
                            'Create',
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          )),
                    );
                  },
                ),
              ],
              title: Text(
                'Edit Video Schema',
                style: TextStyle(
                  fontSize: 20,
                ),
              )),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Video Thumbnail
                  Stack(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 200,
                        child: CachedNetworkImage(
                          imageUrl: widget.videoSchema.thumbnailUrl!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest,
                              child:
                                  Center(child: CircularProgressIndicator())),
                        ),
                      ),
                      Positioned(
                          left: 77,
                          top: 50,
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(59, 130, 246, 1),
                                  borderRadius: BorderRadius.circular(8)),
                              width: 257,
                              height: 60,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4),
                                child: Center(
                                  child: Text(
                                      _titleController.text.toUpperCase(),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      style: TextStyle(
                                          color: Colors.white,
                                          height: 1.2,
                                          fontSize: 23,
                                          fontWeight: FontWeight.w700)),
                                ),
                              )))
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  // Video Title
                  SizedBox(
                    height: 50,
                    child: TextField(
                      controller: _titleController,
                      focusNode: _focusNode,
                      style: TextStyle(fontSize: 30),
                      maxLines: 2,
                      decoration: InputDecoration(
                          hintStyle: TextStyle(fontSize: 28),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          hintText: 'Video Title...',
                          border: InputBorder.none,
                          fillColor: Colors.transparent),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextDivider(
                      placeholder: "and",
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  // Video Title Style
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Choose title style',
                            style: TextStyle(fontSize: 18)),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedStyle = 0;
                                  });
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surfaceContainerHighest,
                                        border: Border.all(
                                          color: _selectedStyle == 0
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                              : Colors.transparent,
                                          width: 3,
                                        ),
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/slide_style_1.jpg'),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                              SizedBox(width: 20),
                              Expanded(
                                  child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedStyle = 1;
                                  });
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surfaceContainerHighest,
                                        border: Border.all(
                                          color: _selectedStyle == 1
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                              : Colors.transparent,
                                          width: 3,
                                        ),
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/slide_style_2.png'),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  // Duration picker
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Video duration',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        DropdownButtonFormField<int>(
                          value: _selectedTimeInSeconds,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          items: _timeOptions.map((option) {
                            return DropdownMenuItem<int>(
                              value: option['value'],
                              child: Text(option['label']),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedTimeInSeconds = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  // Video BG theme
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Background theme',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 160,
                          width: double.infinity,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedSeason = seasons[index];
                                  });
                                },
                                child: Container(
                                  height: 160,
                                  width: 150,
                                  margin: EdgeInsets.only(right: 20),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: _selectedSeason == seasons[index]
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Colors.transparent,
                                      width: 3,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images/${_seasonStyle == 2 ? 'alter/' : ''}${seasons[index].name}.JPG"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: 4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Video Quality
                  SizedBox(
                    height: 40,
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '1080p (FHD) video quality',
                              style: TextStyle(fontSize: 18),
                            ),
                            Switch(
                              value: _scale != "1",
                              onChanged: (value) {
                                setState(() {
                                  _scale = value ? "1.5" : "1";
                                });
                              },
                            )
                          ])),
                  // Bg Music
                  SizedBox(height: 30),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Background music',
                                style: TextStyle(fontSize: 18)),
                            IconButton.outlined(
                                iconSize: 20,
                                style: OutlinedButton.styleFrom(
                                  fixedSize: Size(10, 10),
                                ),
                                onPressed: () {
                                  showMusicModal(
                                      context, _selectedSong!, setSong);
                                },
                                icon: Icon(Icons.replay_outlined))
                          ],
                        ),
                        SizedBox(height: 20),
                        MusicPlayer(selectedSong: _selectedSong)
                      ],
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
