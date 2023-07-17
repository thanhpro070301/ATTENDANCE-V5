import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:attendance_/common/enum/message_enum.dart';
import 'package:attendance_/common/values/theme.dart';

import 'package:attendance_/pages/chat/widgets/video_played_item.dart';

class DisplayTextImageGIF extends StatefulWidget {
  final String message;
  final MessageEnum type;
  const DisplayTextImageGIF(
      {super.key, required this.message, required this.type});

  @override
  State<DisplayTextImageGIF> createState() => _DisplayTextImageGIFState();
}

class _DisplayTextImageGIFState extends State<DisplayTextImageGIF> {
  bool isPlaying = false;
  Duration audioDuration = const Duration();
  final AudioPlayer audioPlayer = AudioPlayer();
  @override
  void initState() {
    super.initState();
    audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        isPlaying = false;
      });
    });
  }

  void updateAudioDuration(Duration duration) {
    setState(() {
      audioDuration = duration;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.type == MessageEnum.text
        ? Text(widget.message,
            style: TextStyle(fontSize: 16.sp, color: AppTheme.darkerText))
        : widget.type == MessageEnum.video
            ? VideoPlayedItem(
                videoUrl: widget.message,
              )
            : widget.type == MessageEnum.audio
                ? GestureDetector(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Icon(
                        isPlaying
                            ? Icons.pause_circle_filled_rounded
                            : Icons.play_circle_fill_rounded,
                      ),
                    ),
                    onTap: () async {
                      HapticFeedback.heavyImpact();
                      if (isPlaying) {
                        await audioPlayer.pause();
                        setState(() {
                          isPlaying = false;
                        });
                      } else {
                        await audioPlayer.play(
                          UrlSource(widget.message),
                        );
                        setState(() {
                          isPlaying = true;
                        });
                      }
                    },
                  )
                : widget.type == MessageEnum.gif
                    ? CachedNetworkImage(
                        imageUrl: widget.message,
                      )
                    : CachedNetworkImage(
                        imageUrl: widget.message,
                      );
  }
}
