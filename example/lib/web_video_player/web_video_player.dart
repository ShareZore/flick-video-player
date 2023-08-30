import 'package:example/utils/mock_data.dart';
import 'package:example/web_video_player/web_video_control.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:video_player/video_player.dart';

import 'data_manager.dart';

class WebVideoPlayer extends StatefulWidget {
  WebVideoPlayer({Key? key}) : super(key: key);

  @override
  _WebVideoPlayerState createState() => _WebVideoPlayerState();
}

class _WebVideoPlayerState extends State<WebVideoPlayer> {
  late FlickManager flickManager;
  late DataManager? dataManager;

  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.network(
        "https://vod.pipi.cn/43903a81vodtransgzp1251246104/bbd4f07a5285890808066187974/v.f42906.mp4",
      ),
    );
    List<String> urls = [
      "https://vod.pipi.cn/43903a81vodtransgzp1251246104/bbd4f07a5285890808066187974/v.f42906.mp4",
      "https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8",
      "https://video-api.ddhmit.net/file/url?t=c08c8199e7f5e874dca63af55cf23e2bf57fbf0ae6b8e2bbb6a898303ca6fa40034c34e947fcb2847995de5dc657a802c70c790968a1b56771f27fb39a6ed39c27f9ed039e918c8627e5fe077ed6c26101dbd7def896dca098df6a2f82239c5568f45c756c4a847f5cf3fd8d15f3cd44b57f4aa70c0098d431b0a1717034d48e",
    ];

    dataManager = DataManager(flickManager: flickManager, urls: urls);
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: ObjectKey(flickManager),
      onVisibilityChanged: (visibility) {
        if (visibility.visibleFraction == 0 && this.mounted) {
          flickManager.flickControlManager?.autoPause();
        } else if (visibility.visibleFraction == 1) {
          flickManager.flickControlManager?.autoResume();
        }
      },
      child: Container(
        child: FlickVideoPlayer(
          flickManager: flickManager,
          flickVideoWithControls: FlickVideoWithControls(
            controls: WebVideoControl(
              dataManager: dataManager!,
              iconSize: 30,
              fontSize: 14,
              progressBarSettings: FlickProgressBarSettings(
                height: 5,
                handleRadius: 5.5,
              ),
            ),
            videoFit: BoxFit.contain,
            // aspectRatioWhenLoading: 4 / 3,
          ),
        ),
      ),
    );
  }
}
