/*
{ 
	accessToken: "eq433",
	renderQueueId: "12345",
    option: {
        title: 'My video',
        titleStyle: 0 / 1,
        bgMusic: '/assets/audio/1.mp3',
        bgVideoTheme: 'spring' | 'summer' | 'autumn' | 'winter' -> getDateFromSeason,
        maxDuration?: 20,
    }
}
*/

class VideoSchema {
  final String videoRenderId;
  final String videoTitle;
  final int titleStyle;
  final String bgMusic;
  final String bgVideoTheme;
  final int? maxDuration;

  VideoSchema(
      {required this.videoRenderId,
      required this.videoTitle,
      required this.titleStyle,
      required this.bgMusic,
      required this.bgVideoTheme,
      this.maxDuration});
}
