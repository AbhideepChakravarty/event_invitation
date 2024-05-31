import 'package:cloud_firestore/cloud_firestore.dart';

class MediaContent {
  final String thumbnailUrl;
  final String compressedMediaURL;
  final String originalMediaURL; // Assuming you have logic to construct this

  MediaContent(
      {required this.thumbnailUrl,
      required this.compressedMediaURL,
      required this.originalMediaURL});

  factory MediaContent.fromFirestore(DocumentSnapshot doc) {
    final thumbnailUrl = doc.get('thumbnailURL') as String;
    final compressedMediaURL = doc.get('compressedMediaURL') as String;
    final originalMediaURL = doc.get('compressedMediaURL') as String;

    return MediaContent(
      thumbnailUrl: thumbnailUrl,
      compressedMediaURL: compressedMediaURL,
      originalMediaURL: originalMediaURL,
    );
  }
}
