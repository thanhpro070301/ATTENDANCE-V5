import 'package:attendance_/common/values/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

class VideoPlayedItem extends ConsumerStatefulWidget {
  final String videoUrl;
  const VideoPlayedItem({super.key, required this.videoUrl});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VideoPlayedItemState();
}

class _VideoPlayedItemState extends ConsumerState<VideoPlayedItem> {
  late VideoPlayerController _videoPlayedController;
  bool isPlay = true;
  @override
  void initState() {
    super.initState();
    _videoPlayedController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
          ..initialize().then(
            (value) {
              _videoPlayedController.setVolume(50);
            },
          );
    _videoPlayedController.addListener(_handlePlayAndPause);
  }

  void _handlePlayAndPause() {
    if (isPlay && !_videoPlayedController.value.isPlaying) {
      setState(() {
        isPlay = false;
      });
    } else {
      setState(() {
        isPlay = true;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayedController.removeListener(_handlePlayAndPause);
    _videoPlayedController.pause();
    _videoPlayedController.pause();

    _videoPlayedController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          VideoPlayer(_videoPlayedController),
          ClosedCaption(text: _videoPlayedController.value.caption.text),
          VideoProgressIndicator(_videoPlayedController, allowScrubbing: true),

          AnimatedSwitcher(
            duration: const Duration(milliseconds: 50),
            reverseDuration: const Duration(milliseconds: 200),
            child: _videoPlayedController.value.isPlaying
                ? const SizedBox.shrink()
                : Container(
                    color: Colors.transparent,
                    child: const Center(
                      child: Icon(
                        Icons.play_arrow,
                        color: AppTheme.nearlyWhite,
                        size: 50.0,
                        semanticLabel: 'Play',
                      ),
                    ),
                  ),
          ),
          GestureDetector(
            onTap: () {
              HapticFeedback.heavyImpact();
              _videoPlayedController.value.isPlaying
                  ? _videoPlayedController.pause()
                  : _videoPlayedController.play();
            },
          ),
          // Align(
          //   alignment: Alignment.center,
          //   child: IconButton(
          //     icon: Icon(
          //       isPlay ? Ionicons.pause_outline : Ionicons.play_outline,
          //       size: 25.r,
          //       color: AppTheme.nearlyWhite,
          //     ),
          //     onPressed: () {
          //       if (isPlay) {
          //         _videoPlayedController.pause();
          //       } else {
          //         _videoPlayedController.play();
          //       }

          //       setState(() {
          //         isPlay = !isPlay;
          //       });
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
