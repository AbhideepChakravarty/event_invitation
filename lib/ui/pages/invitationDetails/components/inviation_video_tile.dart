import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../../helpers/components/circular_progress_indicator.dart';
import '../../../helpers/media/video_player.dart';
import '../../../helpers/theme/font_provider.dart';

class InviationVideoTile extends StatefulWidget {
  final String videoUrl;
  final String thumbnailURL;

  InviationVideoTile(
      {super.key, required this.thumbnailURL, required this.videoUrl});

  @override
  State<InviationVideoTile> createState() => _InviationVideoTileState();
}

class _InviationVideoTileState extends State<InviationVideoTile> {
  var videoPlayerController;

  var chewieController;

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

 
  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[200],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: Text('Invitation',
                    style: Provider.of<FontProvider>(context)
                        .secondaryTextFont
                        .copyWith(fontSize: 24, color: Color(0xFF980147)))),
            const SizedBox(height: 16),
            // Add video player widget here
            /*ChewieVideoPlayer(
                videoUrl: videoUrl,

                    //"https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4"
                    //'https://firebasestorage.googleapis.com/v0/b/weddingproject-175d4.appspot.com/o/invitation_groom.mp4?alt=media&token=7400ba32-25a8-44c0-8841-990ce1a1bcf6',
                  
                thumbnailURL:
                    "https://d1csarkz8obe9u.cloudfront.net/posterpreviews/wedding-poster-template-design-0ba8e5d005c628883315ade7d34ef826_screen.jpg?ts=1655033812")*/
            chewieController == null ? Center(child: AdaptiveCircularProgressIndicator(labelText: "Loading Video....",)) : Chewie(
              controller: chewieController,
            ),
          ],
        ),
      ),
    );
  }
  
  Future<void> _initPlayer() async {
    videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    await  videoPlayerController.initialize();

    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: false,
      looping: true,
      //aspectRatio: 9/16,
    );
     setState(() {});
  }
}
