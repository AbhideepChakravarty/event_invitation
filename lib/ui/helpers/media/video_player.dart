import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ChewieVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final String thumbnailURL;

  const ChewieVideoPlayer(
      {super.key, required this.videoUrl, required this.thumbnailURL});

  @override
  _ChewieVideoPlayerState createState() => _ChewieVideoPlayerState();
}

class _ChewieVideoPlayerState extends State<ChewieVideoPlayer> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: false,
        looping: false,
        aspectRatio: 16 / 9,
        placeholder: Image.network(widget.thumbnailURL)
        // Other configuration options
        );
    //_initializePlayer();
  }

  @override
  void dispose() {
    _chewieController!.dispose();
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: AspectRatio(
      aspectRatio: 16 / 9,
      child: Chewie(
        controller: _chewieController!,
      ),
    ));
  }

  Future<void> _initializePlayer() async {
    //print("Going to initialize the video");
    await Future.wait([_videoPlayerController.initialize()]);
    //print("Going to initialize the video done.");

    setState(() {});
  }
}
