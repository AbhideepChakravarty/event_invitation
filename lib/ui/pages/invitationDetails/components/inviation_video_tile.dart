import 'package:flutter/material.dart';

import 'video_player.dart';

class InviationVideoTile extends StatelessWidget {
  const InviationVideoTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[200],
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: const Text(
                'Invitation',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16),
            // Add video player widget here
            ChewieVideoPlayer(
                videoUrl:
                    //"https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4"
                    'https://firebasestorage.googleapis.com/v0/b/weddingproject-175d4.appspot.com/o/invitation_groom.mp4?alt=media&token=7400ba32-25a8-44c0-8841-990ce1a1bcf6',
                thumbnailURL:
                    "https://d1csarkz8obe9u.cloudfront.net/posterpreviews/wedding-poster-template-design-0ba8e5d005c628883315ade7d34ef826_screen.jpg?ts=1655033812"),
          ],
        ),
      ),
    );
  }
}
