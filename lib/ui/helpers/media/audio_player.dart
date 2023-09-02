import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioPlayerWidget extends StatefulWidget {
  final Uri audioUri;

  const AudioPlayerWidget({required this.audioUri, Key? key}) : super(key: key);

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer audioPlayer;
  double _currentPosition = 0.0;
  double _totalDuration = 1.0; // To avoid division by zero
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    _initializeAudioPlayer();
  }

  void _initializeAudioPlayer() {
    audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _totalDuration = duration.inMilliseconds.toDouble();
      });
    });

    audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        _currentPosition = position.inMilliseconds.toDouble();
      });
    });

    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        _isPlaying = (state == PlayerState.playing);
      });
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  void _play() async {
    await audioPlayer.play(UrlSource(widget.audioUri.toString()));

    setState(() {
      _isPlaying = true;
    });
  }

  void _pause() async {
    await audioPlayer.pause();
    setState(() {
      _isPlaying = false;
    });
  }

  void _stop() async {
    await audioPlayer.stop();
    setState(() {
      _isPlaying = false;
      _currentPosition = 0.0;
    });
  }

  void _seekTo(double position) {
    audioPlayer.seek(Duration(milliseconds: position.toInt()));
    setState(() {
      _currentPosition = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Slider(
          min: 0.0,
          max: _totalDuration,
          value: _currentPosition,
          onChanged: _seekTo,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.play_arrow),
              onPressed: _isPlaying ? null : _play,
            ),
            IconButton(
              icon: Icon(Icons.pause),
              onPressed: _isPlaying ? _pause : null,
            ),
            IconButton(
              icon: Icon(Icons.stop),
              onPressed: _isPlaying ? _stop : null,
            ),
          ],
        ),
      ],
    );
  }
}
